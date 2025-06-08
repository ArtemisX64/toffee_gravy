import 'dart:convert';

import 'package:toffee_gravy/model/codecs/caudio.dart';
import 'package:toffee_gravy/model/codecs/cvideo.dart';
import 'package:toffee_gravy/model/thumbnail.dart';
import 'package:toffee_gravy/reverse/youtube/internal/api.dart';
import 'package:toffee_gravy/reverse/youtube/internal/handlers/url_handler.dart';
import 'package:toffee_gravy/reverse/youtube/internal/models/stream_info.dart';
import 'package:toffee_gravy/reverse/youtube/youtube_client_handler.dart';
import 'package:toffee_gravy/utils/exceptions.dart';



class StreamHandler {
  String? _visitorData;
  YoutubeApi _api;
  final YoutubeClient _client;

  StreamHandler(this._client, this._api);

  Future<List<StreamInfo>> getStreams(List<String> ids) async {
    List<StreamInfo> streams = [];
    for (final id in ids) {
      streams.add(await getStream(id));
    }
    return streams;
  }

  Future<StreamInfo> getStream(String id) async {
    final visitorData = _visitorData ?? await _getVisitorData();

    final body = {
      'context': {
        'client': {
          'clientName': _api.clientName,
          'clientVersion': _api.clientVersion,
          if (_api.deviceMake != null) 'deviceMake': _api.deviceMake,
          if (_api.deviceModel != null) 'deviceModel': _api.deviceModel,
          if (_api.hl != null) 'hl': _api.hl,
          if (_api.platform != null) "platform": _api.platform,
          if (_api.osName != null) 'osName': _api.osName,
          if (_api.osVersion != null) 'osVersion': _api.osVersion,
          if (_api.timeZone != null) 'timeZone': _api.timeZone,
          if (_api.userAgent != null)
            'userAgent':
                _api.userAgent,
          if (_api.gl != null) 'gl': _api.gl,
          if(_api.androidSdkVersion != null) 'androidSdkVersion' : _api.androidSdkVersion,
          if (_api.utcOffsetMinutes != null) 'utcOffsetMinutes': _api.utcOffsetMinutes,
          'visitorData': visitorData,
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
      headers: _api.generateHeader(),
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
    if(jKeywords != null){
    for (final keyword in jKeywords){
      keywords.add(keyword.toString());
    }
    }
  
    //Thumbnail
     Thumbnail? channelThumbnails;
    final elements = jsonResponse["endscreen"]?["endscreenRenderer"]?["elements"];
    if(elements != null){
    var jChannelThumbnails = [];
    for (var element in elements) {
      if (element['endscreenElementRenderer']?['style'].contains('CHANNEL')) {
        jChannelThumbnails =
            element['endscreenElementRenderer']?['image']?['thumbnails'];
        break;
      }
    }
    Map<(int, int), String> mChannelThumbnails = {};
    
    if (jChannelThumbnails.isNotEmpty) {
      for (final thumbnail in jChannelThumbnails) {
        mChannelThumbnails[(thumbnail['width'], thumbnail['height'])] =
            thumbnail['url'];
      }
    }
    if (mChannelThumbnails.isNotEmpty) {
      channelThumbnails = Thumbnail(mChannelThumbnails);
    }
    }
    //Streams
    final streamingData = jsonResponse['streamingData']?['adaptiveFormats'];
    Map<dynamic, String> streamUrls = {};
    for(final data in streamingData){
     if (data["audioQuality"] != null) {
        final codec = AudioCodec(data["mimeType"], data["audioQuality"]);
        streamUrls[codec] = data["url"];
      }
      else if (data["qualityLabel"] != null) {
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
      channelThumbnail: channelThumbnails,
      streamUrls: streamUrls,
    );
  }

  //Mitigate signin error in IOS
  Future<String> _getVisitorData() async {
    if (_api.userAgent == null) {
      throw RequestParameterNotFound(
        message: 'User Agent is Required for this operation',
      );
    }
    var response = await _client.getResponseAsString(
      'https://www.youtube.com/sw.js_data',
      reqType: RequestType.get,
      headers: {
        if (_api.userAgent != null) 'User-Agent': _api.userAgent!,
        'Content-Type': 'application/json',
      },
    );

    if (response.startsWith(")]}'")) {
      response = response.substring(4);
    }

    final List<dynamic> data = json.decode(response);
    _visitorData = data[0][2][0][0][13];
    return _visitorData!;
  }

  void changeApi(YoutubeApi api) => _api = api;
}
