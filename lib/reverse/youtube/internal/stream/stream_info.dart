import 'package:toffee_gravy/model/thumbnail.dart';


class StreamInfo {
  final String id;
  final String title;
  final String author;
  final String channelId;
  final String? description;
  final List<String> tags;
  final Thumbnail? channelThumbnail;
  final String? playlistId;
  final int? views;
  
  final Map<dynamic, String>? streamUrls;
  

  const StreamInfo({
    required this.id,
    required this.title,
    required this.author,
    required this.channelId,
    required this.tags,
    required this.description,
    this.playlistId,
    this.streamUrls,
    this.views,
    this.channelThumbnail,
  });

}
