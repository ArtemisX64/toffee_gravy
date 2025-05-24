import 'package:toffee_gravy/model/codecs/codec.dart';
import 'package:toffee_gravy/model/codecs/cvideo.dart';
import 'package:toffee_gravy/utils/exceptions.dart';

enum MuxedQualityType { q144, q240, q360 }

class MuxedCodec extends Codec {
  late MuxedQualityType quality;
  late VideoCodec codec;
  MuxedCodec(String qualityString, String codecString) {
    switch (qualityString) {
      case ("QUALITY_ORDINAL_144P"):
        quality = MuxedQualityType.q144;
        break;
      case ("QUALITY_ORDINAL_240P"):
        quality = MuxedQualityType.q240;
        break;
      case ("QUALITY_ORDINAL_360P"):
        quality = MuxedQualityType.q360;
        break;
      default:
        throw NoValidCodecFound(message: "Invalid Quality");
    }

    codec = VideoCodec(codecString);

  }
  
  @override
  getCodecType() {
    return quality;
  }
}
