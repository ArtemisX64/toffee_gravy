import 'dart:convert';

import 'package:toffee_gravy/reverse/youtube/internal/api.dart';
import 'package:toffee_gravy/reverse/youtube/internal/handlers/url_handler.dart';
import 'package:toffee_gravy/reverse/youtube/youtube_client_handler.dart';

class PageHandler {
  YoutubeApi _api;
  final YoutubeClient client;
  PageHandler({required this.client, YoutubeApi? api}) : _api = api ?? WebApi();

  Future<Map<dynamic, dynamic>> getPage(String endPoint, String type) async {
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
          if (_api.userAgent != null) 'userAgent': _api.userAgent,
          if (_api.gl != null) 'gl': _api.gl,
          if (_api.androidSdkVersion != null)
            'androidSdkVersion': _api.androidSdkVersion,
          if (_api.utcOffsetMinutes != null)
            'utcOffsetMinutes': _api.utcOffsetMinutes,
        },
      },
      if (endPoint == "browse") 'browseId': type else 'query': type,
    };

    final urlHandler = UrlHandler();
    urlHandler.constructUrl(endPoint);
    final page = await client.getResponseAsString(
      urlHandler.url!,
      reqType: RequestType.post,
      body: body,
    );
    final jsonFile = jsonDecode(page);
    return jsonFile['contents']?['twoColumn${endPoint[0].toUpperCase()}${endPoint.substring(1)}ResultsRenderer'];
  }

  void changeApi(YoutubeApi api) => _api = api;
}
