abstract class Codec {
  String getCodec(String codec) {
    final codecRegex = RegExp("codecs=\"(.*?)(?:\\.|\")");
    return codecRegex.firstMatch(codec)!.group(1)!;
  }

  dynamic getCodecType();
}
