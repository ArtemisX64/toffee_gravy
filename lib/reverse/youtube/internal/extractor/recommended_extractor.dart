import 'dart:convert';

import 'package:toffee_gravy/reverse/youtube/internal/handlers/url_handler.dart';
import 'package:toffee_gravy/toffee_gravy.dart';

class RecommendedExtractor {
  final YoutubeClient _client;
  String? _visitorData;

  final List<Info> videos = [];

  RecommendedExtractor(this._client, {String? visitorData})
    : _visitorData = visitorData;

  Future<void> init({required String id}) async {
    final UrlHandler urlHandler = UrlHandler();
    urlHandler.constructUrl('next');
    final url = urlHandler.url;
    if (url == null) {
      throw BitterToffee("Invalid Url");
    }

    final api = WebApi();
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

    final response = await _client.getResponseAsString(
      url,
      reqType: RequestType.post,
      body: body,
    );
    final jsonResponse = jsonDecode(response);

    final upcoming = getJsonPath(jsonResponse, [
      'contents',
      'twoColumnWatchNextResults',
      'secondaryResults',
      'secondaryResults',
      'results',
    ]);

    upcoming.forEach((resp) {
      final videoDetails = resp['compactVideoRenderer'];
      if (videoDetails != null) {
        final videoId = videoDetails['videoId'];
        final title = getJsonPath(videoDetails, ['title', 'simpleText']);
        final viewCount = getJsonPath(videoDetails, [
          'viewCountText',
          'simpleText',
        ]);
        final length = getJsonPath(videoDetails, ['lengthText', 'simpleText']);
        final published = getJsonPath(videoDetails, [
          'publishedTimeText',
          'simpleText',
        ]);
        final shortViewCount = getJsonPath(videoDetails, [
          'shortViewCountText',
          'simpleText',
        ]);
        final descriptionSnippet = '';

        final channelDetails = getJsonPath(videoDetails, [
          'longBylineText',
          'runs',
          0,
        ]);
        final channelThumbnail = getJsonPath(videoDetails, [
          'channelThumbnail',
          'thumbnails',
        ]);
        String channelThumbnailUrl = '';

        for (final val in channelThumbnail) {
          channelThumbnailUrl = val['url'];
        }
        final channelName = getJsonPath(channelDetails, ['text']);
        final channelId = getJsonPath(channelDetails, [
          'navigationEndpoint',
          'browseEndpoint',
          'browseId',
        ]);
        final channel = BasicChannel(
          channelName,
          channelId,
          channelThumbnailUrl,
        );

        final thumbnailMeta = getJsonPath(videoDetails, [
          'thumbnail',
          'thumbnails',
        ]);
        final Map<(int, int), String> thumbnails = {};
        thumbnailMeta.forEach((val) {
          thumbnails[(val['width'], val['height'])] = val['url'];
        });

        final thumbnail = VideoThumbnail(thumbnails);

        videos.add(
          Info(
            videoId: videoId,
            title: title,
            viewCount: viewCount,
            shortViewCount: shortViewCount,
            descriptionSnippet: descriptionSnippet,
            thumbnail: thumbnail,
            channel: channel,
            length: length,
            published: published,
          ),
        );
      }
    });
  }

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
