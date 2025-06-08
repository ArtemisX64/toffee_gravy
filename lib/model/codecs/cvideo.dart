import 'package:toffee_gravy/model/codecs/codec.dart';
import 'package:toffee_gravy/model/codecs/cquality.dart';
import 'package:toffee_gravy/utils/exceptions.dart';

enum VideoCodecType { avc1, av01, vp09, vp9 }

class VideoCodec extends Codec {
  late final VideoCodecType codec;
  late final VideoQuality quality;
  VideoCodec(String codecString, String qualityString) {
    final videoCodec = super.getCodec(codecString);
    switch (videoCodec) {
      case ("avc1"):
        codec = VideoCodecType.avc1;
        break;
      case ("av01"):
        codec = VideoCodecType.av01;
        break;
      case ("vp09"):
        codec = VideoCodecType.vp09;
        break;
      case ("vp9"):
        codec = VideoCodecType.vp9;
        break;
      default:
        throw NoValidCodecFound(message: videoCodec);
    }

    switch (qualityString) {
      case ("tiny"):
        quality = VideoQuality.sd144;
        break;
      case ("small"):
        quality = VideoQuality.sd240;
        break;
      case ("medium"):
        quality = VideoQuality.sd360;
        break;
      case ("large"):
        quality = VideoQuality.sd480;
        break;
      case ("hd720"):
        quality = VideoQuality.hd720;
        break;
      case ("hd1080"):
        quality = VideoQuality.hd1080;
        break;
      case ("hd1440"):
        quality = VideoQuality.hd1440;
        break;
      case ("hd2160"):
        quality = VideoQuality.hd2160;
        break;
      default:
        throw BitterToffee("Invalid Quality: $qualityString");
    }
  }

  @override
  getCodecType() {
    return VideoCodecType;
  }
}
