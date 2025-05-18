import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:toffee_gravy/utils/constants.dart';
import 'package:toffee_gravy/utils/download.dart';
import 'package:toffee_gravy/utils/utils.dart';

class Trending {
  final String title;
  final String videoId;
  final List<Thumbnail> thumbnails;
  final String viewCount;
  final Channel channel;
  final String length;
  final String published;
  Trending(
    this.title,
    this.videoId,
    this.thumbnails,
    this.viewCount,
    this.channel,
    this.length,
    this.published,
  );
}

class TrendingExtractor with Download {
  List<Trending> trendingList = [];
  TrendingExtractor();
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
            'contents']);
          for (final content in contents) {
            var shelfRenderer = content['itemSectionRenderer']['contents'][0]['shelfRenderer'] ?? '';
            if(shelfRenderer == ''){
              continue;
            }
          
          var items = getJsonPath(content, [
            'itemSectionRenderer',
            'contents',
            0,
            'shelfRenderer',
            'content',
            'expandedShelfContentsRenderer',
            'items',
          ]);
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

            trendingList.add(
              Trending(
                i['title']['runs'][0]['text'],
                videoId,
                thumbnails,
                viewCount,
                channel,
                length,
                published,
              ),
            );
          }
          }
          break; // Break after finding the correct script
        }
        }
      }

    }
  }

