import 'package:toffee_gravy/model/thumbnail.dart';

class ChannelInfo {
  final String id;
  final String title;
  final String channelUrl;
  final String subscribers;
  final Banner? banner;
  final List<String> tags;
  final bool familySafe;
  final Avatar avatar;

  const ChannelInfo({
    required this.id,
    required this.title,
    required this.channelUrl,
    required this.banner,
    required this.familySafe,
    required this.tags,
    required this.avatar,
    required this.subscribers,
  });
}
