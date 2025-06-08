import 'package:toffee_gravy/model/codecs/codec.dart';
import 'package:toffee_gravy/model/codecs/cquality.dart';
import 'package:toffee_gravy/utils/exceptions.dart';

enum AudioCodecType { mp4a, opus }

class AudioCodec extends Codec {
  late final AudioCodecType codec;
  late final AudioQuality quality;

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

    switch (audioQuality) {
      case ('AUDIO_QUALITY_MEDIUM'):
        quality = AudioQuality.medium;
        break;
      case ('AUDIO_QUALITY_LOW'):
        quality = AudioQuality.small;
        break;
      case ('AUDIO_QUALITY_ULTRALOW'):
        quality = AudioQuality.tiny;
        break;
      default:
        throw BitterToffee('Audio Quality Error: $audioQuality');
    }
  }

  @override
  getCodecType() {
    return AudioCodecType;
  }
}
