class Thumbnail {
  late Map<ThumbnailQuality, String> thumbnail;
  Thumbnail(Map<(int, int), String> thumbnails) {
    thumbnails.forEach((key, value) {
      switch (key) {
        case (250, 250):
          thumbnail = {ThumbnailQuality.q250: value};
          break;
        case (400, 400):
          thumbnail = {ThumbnailQuality.q400: value};
          break;
        default:
          print("Invalid quality: $key");
      }
    });
  }

  String? getThumbnailUrl(ThumbnailQuality quality) => thumbnail[quality];
}

enum ThumbnailQuality { q250, q400 }
