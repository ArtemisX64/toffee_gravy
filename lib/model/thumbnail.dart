class Thumbnail {
  late Map<ThumbnailQuality, String> thumbnail;
  Thumbnail(Map<(int, int), String> thumbnails) {
    thumbnails.forEach((key, value) {
      switch (key) {
        case (210, 118):
          thumbnail = {ThumbnailQuality.q118: value};
          break;
        case (246, 138):
          thumbnail = {ThumbnailQuality.q138: value};
          break;
        case (250, 250):
          thumbnail = {ThumbnailQuality.q250: value};
          break;
        case (336, 188):
          thumbnail = {ThumbnailQuality.q188: value};
          break;
        case (400, 400):
          thumbnail = {ThumbnailQuality.q400: value};
          break;
        case (405, 720):
          thumbnail = {ThumbnailQuality.q720: value};
          break;
        default:
          print("Invalid quality: $key");
      }
    });
  }

  String? getThumbnailUrl(ThumbnailQuality quality) => thumbnail[quality];
}

enum ThumbnailQuality { q250, q400, q118, q138, q188, q720 }
