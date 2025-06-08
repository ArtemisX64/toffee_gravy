import 'package:toffee_gravy/model/codecs/cquality.dart';

class VideoThumbnail extends _Thumbnail {
  VideoThumbnail(Map<(int, int), String> thumbnails) {
    final Map<ThumbnailQuality, String> thumbnail = {};
    thumbnails.forEach((key, value) {
      switch (key) {
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
        thumbnail[ThumbnailQuality.large] = value;
        break;
        default:
          print("Invalid quality: $key");
      }
    });

    super.thumbnail = thumbnail;
  }
}

class Avatar extends _Thumbnail {
  Avatar(Map<(int, int), String> thumbnails) {
    final Map<AvatarQuality, String> thumbnail = {};
    thumbnails.forEach((key, value) {
      switch (key) {
        case (900, 900):
          thumbnail[AvatarQuality.large] = value;
          break;
        default:
          print("Invalid quality: $key");
      }
    });

    super.thumbnail = thumbnail;
  }
}

class _Thumbnail {
  late final Map<dynamic, String> thumbnail;

  //The quality can be thumbnail quality or avatar quality
  String? getThumbnailUrl(dynamic quality) => thumbnail[quality];

  String? getThumbnailGeneric(dynamic quality) =>
      getThumbnailUrl(quality)?.split("?")[0];
}
