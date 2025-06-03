class Thumbnail {
  late Map<ThumbnailQuality, String> thumbnail;
  Thumbnail(Map<(int, int), String> thumbnails) {
    thumbnails.forEach((key, value) {
      switch (key) {
        case (210, 118):
          thumbnail = {ThumbnailQuality.low: value};
          break;
        case (246, 138):
          thumbnail = {ThumbnailQuality.medium: value};
          break;
        case (250, 250):
          thumbnail = {ThumbnailQuality.low: value};
          break;
        case (336, 188):
          thumbnail = {ThumbnailQuality.high: value};
          break;
        case (400, 400):
          thumbnail = {ThumbnailQuality.high: value};
          break;
        case (405, 720):
          thumbnail = {ThumbnailQuality.h720: value};
          break;
        default:
          print("Invalid quality: $key");
      }
    });
  }

  String? getThumbnailUrl(ThumbnailQuality quality) => thumbnail[quality];
}

enum ThumbnailQuality { h720, low, medium, high }
