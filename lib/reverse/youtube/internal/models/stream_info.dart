import 'package:toffee_gravy/model/thumbnail.dart';


class StreamInfo {
  final String id;
  final String title;
  final String author;
  final String channelId;
  final String? description;
  final List<String> tags;
  final String? playlistId;
  final int? views;
  
  final Map<dynamic, String> _streamUrls;
  

  StreamInfo({
    required this.id,
    required this.title,
    required this.author,
    required this.channelId,
    required this.tags,
    required this.description,
    
    this.playlistId,
    this.views,
    Map<dynamic, String>? streamUrls,
  }): _streamUrls = streamUrls ?? {};

  Map<dynamic, String>? getStreams() {
    if(_streamUrls.isEmpty) {
      return null;
    }
    return _streamUrls;
  }

}
