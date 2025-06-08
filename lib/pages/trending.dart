import 'package:toffee_gravy/model/thumbnail.dart';
import 'package:toffee_gravy/model/trending_info.dart';
import 'package:toffee_gravy/reverse/youtube/internal/api.dart';
import 'package:toffee_gravy/reverse/youtube/internal/handlers/page_handler.dart';
import 'package:toffee_gravy/reverse/youtube/youtube_client_handler.dart';
import 'package:toffee_gravy/utils/utils.dart' show BasicChannel, getJsonPath;

class Trending {
  
  final YoutubeClient client;
  final List<ShortInfo> shorts = [];
  final List<Info> videos = [];

  //Will be Initialised later
  late final PageHandler handler;
  late final YoutubeApi _api;
  
  Trending({required this.client, YoutubeApi? api}) {
    _api = api ?? WebApi();
    handler = PageHandler(client: client, api: _api);
  }

  Future<void> init() async {
    final trending = await handler.getPage('browse', 'FEtrending');
    var contents = getJsonPath(trending, [
      'tabs',
      0,
      'tabRenderer',
      'content',
      'sectionListRenderer',
      'contents',
    ]);
    for (final content in contents) {
      if (content['itemSectionRenderer']['contents'][0]['shelfRenderer'] !=
          null) {
        var items = getJsonPath(content, [
          'itemSectionRenderer',
          'contents',
          0,
          'shelfRenderer',
          'content',
          'expandedShelfContentsRenderer',
          'items',
        ]);
        if (items == null) {
          continue;
        }

        for (var item in items) {
          final i = item['videoRenderer'];
          final videoId = i['videoId'];
          final viewCount = i['viewCountText']['simpleText'];
          final descriptionSnippet = getJsonPath(i, [
            'descriptionSnippet',
            'runs',
            0,
            'text',
          ]);
          final shortViewCount = i['shortViewCountText']['simpleText'];
          final owner = i["ownerText"]["runs"][0];
          final avatar = getJsonPath(i, [
            'avatar',
            'decoratedAvatarViewModel',
            'avatar',
            'avatarViewModel',
            'image',
            'sources',
            0,
            'url',
          ]);
          final channel = BasicChannel(
            owner['text'],
            owner['navigationEndpoint']['browseEndpoint']['canonicalBaseUrl'],
            avatar,
          );
          final length = i['lengthText']['simpleText'];
          final published = i['publishedTimeText']['simpleText'];

          Map<(int, int), String> thumbnails = {};
          for (var thumbnail in i['thumbnail']['thumbnails']) {
            thumbnails[(thumbnail['width'], thumbnail['height'])] =
                thumbnail['url'];
          }

          videos.add(
            Info(
              title: i['title']['runs'][0]['text'],
              videoId: videoId,
              descriptionSnippet: descriptionSnippet,
              thumbnail: VideoThumbnail(thumbnails),
              viewCount: viewCount,
              shortViewCount: shortViewCount,
              channel: channel,
              length: length,
              published: published,
            ),
          );
        }
      } else if (content['itemSectionRenderer']['contents'][0]['reelShelfRenderer'] !=
          null) {
        var items = getJsonPath(content, [
          'itemSectionRenderer',
          'contents',
          0,
          'reelShelfRenderer',
          'items',
        ]);
        if (items == null) {
          continue;
        }

        for (var item in items) {
          final i = item['shortsLockupViewModel'];
          final videoId = getJsonPath(i, [
            'onTap',
            'innertubeCommand',
            'reelWatchEndpoint',
            'videoId',
          ]);
          final viewCount = getJsonPath(i, [
            'overlayMetadata',
            'secondaryText',
            'content',
          ]);
          final title = getJsonPath(i, [
            'overlayMetadata',
            'primaryText',
            'content',
          ]);
          final descriptionSnippet = getJsonPath(i, [
            'descriptionSnippet',
            'runs',
            0,
            'text',
          ]);

          final thumbs = i['thumbnail']['sources'][0];
          final Map<(int, int), String> thumbnail = {
            (thumbs['width'], thumbs['height']): thumbs['url'],
          };

          shorts.add(
            ShortInfo(
              title: title,
              videoId: videoId,
              descriptionSnippet: descriptionSnippet,
              thumbnail: VideoThumbnail(thumbnail),
              viewCount: viewCount,
            ),
          );
        }
      } else {
        continue;
      }
    }
  }
}
