import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:toffee_gravy/utils/constants.dart';
import 'package:toffee_gravy/utils/download.dart';
import 'package:toffee_gravy/utils/utils.dart';
//?gl=JP
class Trending {
  final String title;
  final String videoId;
  final List<Thumbnail> thumbnails;
  final String viewCount;
  final Channel channel;
  final String length;
  final String published;
  Trending({
    required this.title,
    required this.videoId,
    required this.thumbnails,
    required this.viewCount,
    required this.channel,
    required this.length,
    required this.published,
  });
}

class TrendingShort {
  final String title;
  final String videoId;
  final Thumbnail thumbnail;
  final String viewCount;

  TrendingShort({
    required this.title,
    required this.videoId,
    required this.thumbnail,
    required this.viewCount,
  });
}

class TrendingExtractor with Download {
  List<Trending> trendingVideosList = [];
  List<TrendingShort> trendingShortsList = [];
  CountryCode? countryCode;
  TrendingExtractor({countryCode});
  Future init() async {
    var response = await download(youtubeTrending);
    if (response.statusCode == 200) {
      var document = parse(response.body);
      List<Element> scriptTags = document.querySelectorAll('script');
      final prefix = 'var ytInitialData = ';
      for (var script in scriptTags) {
        if (script.innerHtml.contains(prefix)) {
          final scriptText = script.innerHtml;
          final jsonStart = scriptText.indexOf(prefix) + prefix.length;
          final jsonText = scriptText.substring(jsonStart);
          final jsonEnd = jsonText.indexOf('};') + 1;
          final cleanJson = jsonText.substring(0, jsonEnd);
          final jsonContents = jsonDecode(cleanJson);
          var contents = getJsonPath(jsonContents, [
            'contents',
            'twoColumnBrowseResultsRenderer',
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
                final channel = Channel(
                  owner['text'],
                  owner['navigationEndpoint']['browseEndpoint']['canonicalBaseUrl'],
                  avatar,
                );
                final length = i['lengthText']['simpleText'];
                final published = i['publishedTimeText']['simpleText'];

                List<Thumbnail> thumbnails = [];
                for (var thumbnail in i['thumbnail']['thumbnails']) {
                  thumbnails.add(
                    Thumbnail(
                      thumbnail['url'],
                      Dimensions(thumbnail['width'], thumbnail['height']),
                    ),
                  );
                }

                trendingVideosList.add(
                  Trending(
                    title: i['title']['runs'][0]['text'],
                    videoId: videoId,
                    thumbnails: thumbnails,
                    viewCount: viewCount,
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

                final thumbs = i['thumbnail']['sources'][0];
                final thumbnail = Thumbnail(
                      thumbs['url'],
                      Dimensions(thumbs['width'], thumbs['height']),
                    );

                trendingShortsList.add(
                  TrendingShort(
                    title: title,
                    videoId: videoId,
                    thumbnail: thumbnail,
                    viewCount: viewCount,
                  ),
                );
              }
            } else {
              continue;
            }
          }
       
          break; // Break after finding the correct script
        }
      }
    }
  }
}
