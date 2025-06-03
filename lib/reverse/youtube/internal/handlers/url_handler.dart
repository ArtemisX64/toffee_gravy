const _internalAPIPoint = 'https://www.youtube.com/youtubei/v1/';

class UrlHandler {
  String? _url;
  void constructUrl(String endpoint) {
    _url = "$_internalAPIPoint$endpoint?prettyPrint=true";
  }

  String? get url => _url;
}
