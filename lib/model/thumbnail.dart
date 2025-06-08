import 'package:toffee_gravy/model/codecs/cquality.dart';

class Banner extends _Thumbnail {
  Banner(Map<(int, int), String> thumbnails) {
    final Map<BannerQuality, String> thumbnail = {};
    thumbnails.forEach((key, value) {
      switch (key) {
        case (1060, 175):
          thumbnail[BannerQuality.tiny] = value;
          break;
        case (1138, 188):
          thumbnail[BannerQuality.small] = value;
          break;
        case (1707, 283):
          thumbnail[BannerQuality.medium] = value;
          break;
        case (2120, 351):
          thumbnail[BannerQuality.large] = value;
          break;
        case (2276, 377):
          thumbnail[BannerQuality.xl] = value;
          break;
        case (2560, 424):
          thumbnail[BannerQuality.xxl] = value;
          break;
        default:
          print("Invalid quality: $key");
      }
    });

    super._thumbnail = thumbnail;
  }
}

class VideoThumbnail extends _Thumbnail {
  VideoThumbnail(Map<(int, int), String> thumbnails) {
    final Map<ThumbnailQuality, String> thumbnail = {};
    thumbnails.forEach((key, value) {
      switch (key) {
        case (168, 94):
          thumbnail[ThumbnailQuality.veryTiny] = value;
          break;
        case (210, 118):
          thumbnail[ThumbnailQuality.tiny] = value;
          break;
        case (246, 138):
          thumbnail[ThumbnailQuality.small] = value;
          break;
        case (336, 188):
          thumbnail[ThumbnailQuality.medium] = value;
          break;
        case (405, 720):
          thumbnail[ThumbnailQuality.shorts] = value;
          break;
        default:
          print("Invalid quality: $key");
      }
    });

    super._thumbnail = thumbnail;
  }
}

class Avatar extends _Thumbnail {
  Avatar(Map<(int, int), String> thumbnails) {
    final Map<ThumbnailQuality, String> thumbnail = {};
    thumbnails.forEach((key, value) {
      switch (key) {
        case (72, 72):
          thumbnail[ThumbnailQuality.tiny] = value;
          break;
        case (120, 120):
          thumbnail[ThumbnailQuality.small] = value;
          break;
        case (160, 160):
          thumbnail[ThumbnailQuality.medium] = value;
          break;
        case (900, 900):
          thumbnail[ThumbnailQuality.shorts] = value;
          break;
        default:
          print("Invalid quality: $key");
      }
    });

    super._thumbnail = thumbnail;
  }

  String? getThumbnailXL() {
    return super.getThumbnailGeneric(ThumbnailQuality.shorts);
  }
}

class _Thumbnail {
  late final Map<dynamic, String> _thumbnail;

  //The quality can be thumbnail quality or avatar quality
  String? getThumbnailUrl(dynamic quality) => _thumbnail[quality];

  String? getThumbnailGeneric(dynamic quality) =>
      getThumbnailUrl(quality)?.split("?")[0];
}
