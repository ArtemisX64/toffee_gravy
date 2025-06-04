import 'package:toffee_gravy/reverse/youtube/internal/stream/stream_handler.dart';
import 'package:toffee_gravy/reverse/youtube/internal/stream/stream_info.dart';
import 'package:toffee_gravy/toffee_gravy.dart';

class WatchInfo {
  final StreamHandler _handler;
  StreamInfo? videoInfo;
  WatchInfo({required YoutubeClient client, YoutubeApi? api}): _handler = StreamHandler(client, api ?? AndroidVRApi());

  Future<void> initStream(String id) async{
    videoInfo = await _handler.getStream(id);
  }

  List<Cquality>? getAvailableVideoFormats(VideoCodecType videoCodec){
    final keys = videoInfo?.streamUrls?.keys.toList();
    if(keys == null) {
      return null;
    }
    List<Cquality> formats = [];
    for (final key in keys){
      if(key is VideoCodec && key.codec == videoCodec){
        formats.add(key.quality!);
      }
    }
    return formats;

  }

  List<Cquality>? getAvailableAudioFormats(AudioCodecType audioCodec) {
    final keys = videoInfo?.streamUrls?.keys.toList();
    if(keys == null) {
      return null;
    }
    List<Cquality> formats = [];
    for (final key in keys){
      if(key is AudioCodec && key.codec == audioCodec){
        formats.add(key.quality!);
      }
    }
    return formats;
  }

  String? getVideoUrl(VideoCodecType videoCodec,Cquality quality) {
    final keys = videoInfo?.streamUrls?.keys.toList();
    if (keys == null){
      return null;
    }
    for (final key in keys) {
      if(key is VideoCodec && key.codec == videoCodec && key.quality == quality){
        return videoInfo?.streamUrls?[key];
      }
    }
    return null;
  }

  String? getAudioUrl(AudioCodecType audioCodec, Cquality quality) {
    switch(quality) {
      case Cquality.tiny:
      case Cquality.small:
      case Cquality.medium: break;
      default: quality = Cquality.medium;
    }
     final keys = videoInfo?.streamUrls?.keys.toList();
     if(keys == null){
      return null;
     }
      for (final key in keys) {
      if(key is AudioCodec && key.codec == audioCodec && key.quality == quality){
        return videoInfo?.streamUrls?[key];
      }
    }
    return null;
  }


}