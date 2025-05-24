import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toffee_gravy/utils/exceptions.dart';

enum RequestType { get, post }

class YoutubeClient extends http.BaseClient {
  final http.Client _client;
  //To interrupt stream
  bool _closeStream = false;

  bool get closeStream => _closeStream;

  YoutubeClient({http.Client? client}) : _client = client ?? http.Client();

  static const Map<String, String> _defaultHeaders = {
    'user-agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.18 Safari/537.36',
    'cookie': 'CONSENT=YES+cb',
    'accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'accept-language': 'en-US,en;q=0.5',
  };

  void _validateResponse(int statusCode) {
    if (_closeStream) return;

    switch (statusCode) {
      case 400:
        throw HttpNotFoundException();
    }
  }

  Future<String> getResponseAsString(
    String url, {
    required RequestType reqType,
    Map<String, String> headers = const {},
    Object? body,
    Encoding? encoding,
  }) async {
    final response = switch (reqType) {
      RequestType.get => await get(Uri.parse(url), headers: headers),
      RequestType.post => await post(
        Uri.parse(url),
        headers: headers,
        body: body,
        encoding: encoding,
      ),
    };

    return response.body;
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final response = await super.get(url, headers: headers);
    if (_closeStream) throw BitterToffee("Site Closed");

    _validateResponse(response.statusCode);
    return response;
  }

  @override
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    final response = await super.post(
      url,
      headers: headers,
      body: jsonEncode(body),
      encoding: encoding,
    );
    if (_closeStream) throw BitterToffee("Http Client Closed");

    _validateResponse(response.statusCode);

    return response;
  }

  @override
  void close() {
    _closeStream = true;
    _client.close();
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (_closeStream) throw BitterToffee('The stream is stopped');

    _defaultHeaders.forEach((key, val) {
      if (request.headers[key] == null) {
        request.headers[key] = val;
      }
    });

    return _client.send(request);
  }
}
