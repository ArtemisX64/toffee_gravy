import 'package:toffee_gravy/utils/utils.dart' show Channel;
import 'package:toffee_gravy/model/thumbnail.dart';


class TrendingInfo {
  final List<Info> infos;
  final List<Info> shortInfos;
  const TrendingInfo({required this.infos, required this.shortInfos});
}

class Info extends BasicInfo {
  final Channel channel;
  final String length;
  final String published;
  const Info({
    required String videoId,
    required String title,
    required String viewCount,
    required String shortViewCount,
    required String? descriptionSnippet,
    required VideoThumbnail thumbnail,
    required this.channel,
    required this.length,
    required this.published,
  }) : super(videoId, title,descriptionSnippet, viewCount, shortViewCount, thumbnail);
}

class ShortInfo extends BasicInfo {
  const ShortInfo({
    required String videoId,
    required String title,
    required String? descriptionSnippet,
    required String viewCount,
    required VideoThumbnail thumbnail,
  }) : super(videoId, title, descriptionSnippet, viewCount,viewCount, thumbnail);
}

class BasicInfo {
  final String title;
  final String? descriptionSnippet;
  final String videoId;
  final VideoThumbnail thumbnail;
  final String viewCount;
  final String shortViewCount;

  const BasicInfo(
    this.videoId,
    this.title,
    this.descriptionSnippet,
    this.viewCount,
    this.shortViewCount,
    this.thumbnail,
  );
}
