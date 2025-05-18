class Thumbnail {
  final String url;
  final Dimensions dimensions;

  Thumbnail(this.url, this.dimensions);
  
}

class Dimensions {
  final int width;
  final int height;

  Dimensions(this.width, this.height);
}

class Channel {
  final String name;
  final String id;
  final String avatar;

  Channel(this.name, this.id, this.avatar);
}

dynamic getJsonPath(Map json, List keys) {
  dynamic value = json; 
  for (final key in keys) {
    if(value is Map && value.containsKey(key)) {
      value = value[key];
    }
    else if(value is List && key is int && key < value.length) {
      value = value[key];
    }
    else {
      return null;
    }
  }
  return value;
}