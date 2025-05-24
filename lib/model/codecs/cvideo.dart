import 'package:toffee_gravy/model/codecs/codec.dart';
import 'package:toffee_gravy/utils/exceptions.dart';

enum VideoCodecType { avc1,av01, vp09 }
class VideoCodec extends Codec {
  late VideoCodecType codec;
  VideoCodec(String codecString) {
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
      default:
        throw NoValidCodecFound();
    }
  }
  
  @override
  getCodecType() {
    return VideoCodecType;
  }
}
