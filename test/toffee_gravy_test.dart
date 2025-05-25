import 'package:test/test.dart';
import 'package:toffee_gravy/model/codecs/caudio.dart';
import 'package:toffee_gravy/model/codecs/cquality.dart';
import 'package:toffee_gravy/model/codecs/cvideo.dart';
import 'package:toffee_gravy/pages/trending.dart';
import 'package:toffee_gravy/reverse/youtube/internal/api.dart';
import 'package:toffee_gravy/reverse/youtube/internal/stream/stream_handler.dart';
import 'package:toffee_gravy/reverse/youtube/youtube_client_handler.dart';
import 'package:toffee_gravy/utils/utils.dart';

void main() {
  test('trending', () async {
    var trending = TrendingExtractor();
    await trending.init();
  });

  test('get360pVideo', () async {
    var api = IosApi();
    var client = YoutubeClient();

    var youtubeVideoExtractor = StreamHandler(client, api);
    final stream = await youtubeVideoExtractor.getStream("4Hzzdzj-pD4");
    stream.streamUrls!.forEach((key, value) {
      if (key is VideoCodec && key.quality == Cquality.medium) {
        // print(key.codec.codec);
        // print(value);
      }
    });
  });

  test('get1080pVideoForAndroidVR', () async {
    var api = AndroidVRApi();
    var client = YoutubeClient();

    var youtubeVideoExtractor = StreamHandler(client, api);
    final stream = await youtubeVideoExtractor.getStream("qr1AvisQcV8");
    stream.streamUrls!.forEach((key, value) {
      if (key is VideoCodec && key.quality == Cquality.hd1080) {
        // print(key.codec);
        // print(value);
      }
    });
  });

  test('get4KVideoForAndroidVR', () async {
    var api = AndroidVRApi();
    var client = YoutubeClient();

    var youtubeVideoExtractor = StreamHandler(client, api);
    final stream = await youtubeVideoExtractor.getStream("qr1AvisQcV8");
    stream.streamUrls!.forEach((key, value) {
      if (key is VideoCodec && key.quality == Cquality.hd2160) {
        print(key.codec);
        print(value);
      }
    });
  });

  test('get4KVideoForAndroid', () async {
    var api = AndroidApi();
    var client = YoutubeClient();

    var youtubeVideoExtractor = StreamHandler(client, api);
    final stream = await youtubeVideoExtractor.getStream("qr1AvisQcV8");
    stream.streamUrls!.forEach((key, value) {
      if (key is VideoCodec && key.quality == Cquality.hd2160) {
        // print(key.codec);
        // print(value);
      }
    });
  });

  test('getOpusAudio', () async {
    var api = IosApi();
    var client = YoutubeClient();

    var youtubeVideoExtractor = StreamHandler(client, api);
    final stream = await youtubeVideoExtractor.getStream("4Hzzdzj-pD4");
    stream.streamUrls!.forEach((key, value) {
      if (key is AudioCodec && key.codec == AudioCodecType.opus) {
        // print(value);
      }
    });
  });
  test('trending with country code', () async {
    var trending = TrendingExtractor(
      countryCode: CountryCode(country: Country.japan),
    );
    await trending.init();
  });

  test('trending dynamic change country', () async {
    var trending = TrendingExtractor();
    final country = CountryCode(country: Country.japan);
    await trending.init();
    await trending.refreshListWithNewCountry(country);
  });
}
