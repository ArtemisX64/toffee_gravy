import 'package:toffee_gravy/toffee_gravy.dart';

class Channel {
  final String name;
  final Thumbnail avatar; //The main avatar
  final Thumbnail banner; //The banner
  final bool verified;
  final String count;

  const Channel({
    required this.name,
    required this.avatar,
    required this.banner,
    required this.count,
    required this.verified,
  });
}
