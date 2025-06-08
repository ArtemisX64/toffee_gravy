import 'dart:convert';

import 'package:toffee_gravy/model/codecs/caudio.dart';
import 'package:toffee_gravy/model/codecs/cvideo.dart';
import 'package:toffee_gravy/reverse/youtube/internal/api.dart';
import 'package:toffee_gravy/reverse/youtube/internal/handlers/url_handler.dart';
import 'package:toffee_gravy/reverse/youtube/internal/models/stream_info.dart';
import 'package:toffee_gravy/reverse/youtube/youtube_client_handler.dart';
import 'package:toffee_gravy/utils/exceptions.dart';

class StreamHandler {
  String? _visitorData;
  final YoutubeClient _client;

  StreamHandler(this._client, {String? visitorData})
    : _visitorData = visitorData;

  Future<List<StreamInfo>> fetchStreams(
    List<String> ids, {
    YoutubeApi? api,
  }) async {
    api ??= WebApi();
    List<StreamInfo> streams = [];
    for (final id in ids) {
      streams.add(await fetchStream(id));
    }
    return streams;
  }

  Future<StreamInfo> fetchStream(String id, {YoutubeApi? api}) async {
    api ??= WebApi();
    final visitorData = _visitorData ?? await _getVisitorData(api.userAgent);
    final body = {
      'context': {
        'client': {
          'clientName': api.clientName,
          'clientVersion': api.clientVersion,
          if (api.deviceMake != null) 'deviceMake': api.deviceMake,
          if (api.deviceModel != null) 'deviceModel': api.deviceModel,
          if (api.hl != null) 'hl': api.hl,
          if (api.platform != null) "platform": api.platform,
          if (api.osName != null) 'osName': api.osName,
          if (api.osVersion != null) 'osVersion': api.osVersion,
          if (api.timeZone != null) 'timeZone': api.timeZone,
          if (api.userAgent != null) 'userAgent': api.userAgent,
          if (api.gl != null) 'gl': api.gl,
          if (api.androidSdkVersion != null)
            'androidSdkVersion': api.androidSdkVersion,
          if (api.utcOffsetMinutes != null)
            'utcOffsetMinutes': api.utcOffsetMinutes,
          if (visitorData != null) 'visitorData': visitorData,
        },
      },
      "videoId": id,
    };

    var playbackUrl = UrlHandler();
    playbackUrl.constructUrl('player');
    if (playbackUrl.url == null) {
      throw InvalidUrl();
    }

    final response = await _client.getResponseAsString(
      playbackUrl.url!,
      reqType: RequestType.post,
      headers: api.generateHeader(),
      body: body,
    );

    final jsonResponse = jsonDecode(response);
    final videoDetails = jsonResponse["videoDetails"];
    final title = videoDetails["title"];
    final channelId = videoDetails["channelId"];
    final author = videoDetails["author"];
    final viewCount = int.parse(videoDetails["viewCount"]);
    final shortDescription = videoDetails["shortDescription"];
    final jKeywords = videoDetails["keywords"];

    List<String>? keywords = [];
    if (jKeywords != null) {
      for (final keyword in jKeywords) {
        keywords.add(keyword.toString());
      }
    }

    //Streams
    final streamingData = jsonResponse['streamingData']?['adaptiveFormats'];
    Map<dynamic, String> streamUrls = {};
    for (final data in streamingData) {
      if (data["audioQuality"] != null) {
        final codec = AudioCodec(data["mimeType"], data["audioQuality"]);
        streamUrls[codec] = data["url"];
      } else if (data["qualityLabel"] != null) {
        final codec = VideoCodec(data["mimeType"], data["quality"]);
        streamUrls[codec] = data["url"];
      }
    }
    return StreamInfo(
      id: id,
      title: title,
      channelId: channelId,
      author: author,
      views: viewCount,
      description: shortDescription,
      tags: keywords,
      streamUrls: streamUrls,
    );
  }

  //Mitigate signin error in IOS
  Future<String?> _getVisitorData(String? userAgent) async {
    if (userAgent == null) {
      print('User Agent is Required for this operation');
      return null;
    }
    var response = await _client.getResponseAsString(
      'https://www.youtube.com/sw.js_data',
      reqType: RequestType.get,
      headers: {'User-Agent': userAgent, 'Content-Type': 'application/json'},
    );

    if (response.startsWith(")]}'")) {
      response = response.substring(4);
    }

    final List<dynamic> data = json.decode(response);
    _visitorData = data[0][2][0][0][13];
    return _visitorData!;
  }
}
