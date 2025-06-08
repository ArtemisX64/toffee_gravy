import 'package:toffee_gravy/toffee_gravy.dart';

class Channel {
  final String name;
  final Avatar channelAvatar;
  final bool verified;
  final String count;

  const Channel({
    required this.name,
    required this.channelAvatar,
    required this.count,
    required this.verified,
  });
}
