import 'dart:convert';

import 'package:toffee_gravy/reverse/youtube/internal/handlers/url_handler.dart';
import 'package:toffee_gravy/toffee_gravy.dart';

class ChannelExtractor {
  late final ChannelInfo _info;

  Future<void> init({required String id, required YoutubeClient client, YoutubeApi? api}) async{
    api ??= WebApi();
    final body = {
      'context': {
        'client': {
          'clientName': api.clientName,
          'clientVersion': api.clientVersion,
          if (api.hl != null) 'hl': api.hl,
          if (api.timeZone != null) 'timeZone': api.timeZone,
          if (api.userAgent != null)
            'userAgent':
                api.userAgent,
          if (api.gl != null) 'gl': api.gl,
        },
      },
      'browseId': id,
    };

    final handler = UrlHandler();
    handler.constructUrl('browse');
    final url = handler.url!;
    final result = await client.getResponseAsString(url, reqType: RequestType.post, body: body);
    _constructInfo(id, result);
  }

  void _constructInfo(String id, String result) {
    final jsonResult = jsonDecode(result);
    final metadata = jsonResult['metadata'];
    
    //Metadata Contents
    final metadataRenderer = metadata['channelMetadataRenderer'];
    final title = metadataRenderer['title'];
    final channelUrl = metadataRenderer['channelUrl'];
    final familySafe = metadataRenderer['isFamilySafe'];
    final tags = (metadataRenderer['keywords'] as String).split(' ');

    //Header Contents
    final header = jsonResult['header']['pageHeaderRenderer'];
    final headerViewModel = header['content']['pageHeaderViewModel'];
    
    //Avatar
    final avatarMeta = metadataRenderer['avatar']['thumbnails'][0];
    final Map<(int, int), String> newAvatar = {
    (avatarMeta['width'] as int, avatarMeta['height'] as int):  avatarMeta['url'] as String};
    final avatars = getJsonPath(headerViewModel, ['image', 'decoratedAvatarViewModel','avatar','avatarViewModel','image','sources']);
    for (final avatar in avatars){
      newAvatar[(avatar['width'], avatar['height'])] = avatar['url'];
    }
    final avatar = Avatar(newAvatar);

  //Banner
  final bannerMeta = getJsonPath(headerViewModel, ['banner','imageBannerViewModel' , 'image', 'sources']);
  final Map<(int, int), String> newBanner = {};
  for (final banner in bannerMeta) {
    newBanner[(banner['width'], banner['height'])] = banner['url']; 
  }
  final banner = Banner(newBanner);

  //Subscribers
  final subscriberMeta = getJsonPath(headerViewModel, ['metadata', 'contentMetadataViewModel', 'metadataRows', 1, 'metadataParts', 0, 'text', 'content']);
  String subscribers = subscriberMeta;
  if (!subscribers.contains("subscribers")) {
    subscribers = '';
  }


    _info = ChannelInfo(id: id, title: title, channelUrl: channelUrl, banner: banner, familySafe: familySafe, tags: tags, avatar: avatar, subscribers: subscribers);
  }

  String get id => _info.id;
  String get title => _info.title;
  String get channelUrl => _info.channelUrl;
  String get subscribers => _info.subscribers;
  Banner? get banner => _info.banner;
  List<String> get tags => _info.tags;
  bool get familySafe => _info.familySafe;
  Avatar get avatar => _info.avatar;
}