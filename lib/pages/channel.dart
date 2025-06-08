import 'package:toffee_gravy/reverse/youtube/internal/extractor/channel_extractor.dart';
import 'package:toffee_gravy/toffee_gravy.dart';

class Channel {
  final ChannelExtractor _channel = ChannelExtractor();
  Future<void> init({required String id, required YoutubeClient client}) async {
    await _channel.init(id: id, client: client);
  }

  String get id => _channel.id;
  String get title => _channel.title;
  String get channelUrl => _channel.channelUrl;
  String get subscribers => _channel.subscribers;
  Banner? get banner => _channel.banner;
  List<String> get tags => _channel.tags;
  bool get familySafe => _channel.familySafe;
  Avatar get avatar => _channel.avatar;
}