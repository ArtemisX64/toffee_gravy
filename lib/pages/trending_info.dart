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
    required Thumbnail thumbnail,
    required this.channel,
    required this.length,
    required this.published,
  }) : super(videoId, title, viewCount, thumbnail);
}

class ShortInfo extends BasicInfo {
  const ShortInfo({
    required String videoId,
    required String title,
    required String viewCount,
    required Thumbnail thumbnail,
  }) : super(videoId, title, viewCount, thumbnail);
}

class BasicInfo {
  final String title;
  final String videoId;
  final Thumbnail thumbnail;
  final String viewCount;

  const BasicInfo(
    this.videoId,
    this.title,
    this.viewCount,
    this.thumbnail,
  );
}
