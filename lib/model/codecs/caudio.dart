import 'package:toffee_gravy/model/codecs/codec.dart';
import 'package:toffee_gravy/model/codecs/cquality.dart';
import 'package:toffee_gravy/utils/exceptions.dart';

enum AudioCodecType{
  mp4a,
  opus,
}


class AudioCodec extends Codec {
  late AudioCodecType codec;
  late Cquality quality;

  AudioCodec(String codecString, String audioQuality) {
    final audioCodec = super.getCodec(codecString);
    switch (audioCodec) {
      case ("mp4a"):
        codec = AudioCodecType.mp4a;
        break;
      case ("opus"):
        codec = AudioCodecType.opus;
        break;
      default:
        throw NoValidCodecFound(message: audioCodec);
    }

    switch(audioQuality) {
      case ('AUDIO_QUALITY_MEDIUM'): quality = Cquality.medium; break;
      case ('AUDIO_QUALITY_LOW'): quality = Cquality.small; break;
      case ('AUDIO_QUALITY_ULTRALOW'): quality = Cquality.tiny; break;
      default: throw BitterToffee('Audio Quality Error: $audioQuality');
    }
  }
  
  @override
  getCodecType() {
    return AudioCodecType;
  }
}
