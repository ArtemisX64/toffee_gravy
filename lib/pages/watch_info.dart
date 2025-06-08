import 'package:toffee_gravy/reverse/youtube/internal/handlers/stream_handler.dart';
import 'package:toffee_gravy/reverse/youtube/internal/models/stream_info.dart';
import 'package:toffee_gravy/toffee_gravy.dart';

class WatchInfo {
  final StreamHandler _handler;
  late final StreamInfo _info;
  WatchInfo({required YoutubeClient client, YoutubeApi? api}): _handler = StreamHandler(client, api ?? AndroidVRApi());

  Future<void> initStream(String id) async{
   _info = await _handler.getStream(id);
  }


  List<VideoQuality>? getAvailableVideoFormats(VideoCodecType videoCodec){
    final streams = _info.getStreams();
    if(streams == null) {
      return null;
    }
    final keys = streams.keys.toList();
    List<VideoQuality> formats = [];
    for (final key in keys){
      if(key is VideoCodec && key.codec == videoCodec){
        formats.add(key.quality);
      }
    }
    return formats;

  }

  List<AudioQuality>? getAvailableAudioFormats(AudioCodecType audioCodec) {
    final streams = _info.getStreams();
    if (streams == null) {
      return null;
    }
    final keys = streams.keys.toList();
    List<AudioQuality> formats = [];
    for (final key in keys){
      if(key is AudioCodec && key.codec == audioCodec){
        formats.add(key.quality);
      }
    }
    return formats;
  }

  String? getVideoUrl(VideoCodecType videoCodec,VideoQuality quality) {
    final streams = _info.getStreams();
    if (streams == null) {
      return null;
    }
    final keys = streams.keys.toList();
    for (final key in keys) {
      if(key is VideoCodec && key.codec == videoCodec && key.quality == quality){
        return streams[key];
      }
    }
    return null;
  }

  String? getAudioUrl(AudioCodecType audioCodec, AudioQuality quality) {
    final streams = _info.getStreams();
    if (streams == null) {
      return null;
    }
     final keys = streams.keys.toList();
      for (final key in keys) {
      if(key is AudioCodec && key.codec == audioCodec && key.quality == quality){
        return streams[key];
      }
    }
    return null;
  }

  //Getters to required info
  String get title => _info.title;
  String? get description => _info.description;
  String get id => _info.id;
  String get author => _info.author; 
  String get channelId => _info.channelId;
  List<String> get tags => _info.tags;
  int? get views => _info.views;
  String? get playlistId => _info.playlistId;

}