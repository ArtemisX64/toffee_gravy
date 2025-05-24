import 'package:toffee_gravy/model/codecs/codec.dart';
import 'package:toffee_gravy/utils/exceptions.dart';

enum AudioCodecType{
  mp4a,
  opus,
}


class AudioCodec extends Codec {
  late AudioCodecType codec;

  AudioCodec(String codecString) {
    final audioCodec = super.getCodec(codecString);
    switch (audioCodec) {
      case ("mp4a"):
        codec = AudioCodecType.mp4a;
        break;
      case ("opus"):
        codec = AudioCodecType.opus;
        break;
      default:
        throw NoValidCodecFound();
    }
  }
  
  @override
  getCodecType() {
    return AudioCodecType;
  }
}
