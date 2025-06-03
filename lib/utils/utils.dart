
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

enum Country {
  india,
  japan
}

class CountryCode {
  final Country country;
  CountryCode({required this.country});

  String _toString() => switch(country){
    Country.india => "IN"  ,
    Country.japan => "JP",
    };

  String linkHandler(String link) {
    final countryCode = _toString();
    final newLink = "$link?&gl=$countryCode";
    return newLink;
  }
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
