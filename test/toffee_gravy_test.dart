import 'package:test/test.dart';
import 'package:toffee_gravy/reverse/youtube/internal/extractor/recommended_extractor.dart';
import 'package:toffee_gravy/reverse/youtube/internal/handlers/page_handler.dart';
import 'package:toffee_gravy/toffee_gravy.dart';

void main() {
  test('trending', () async {
    var client = YoutubeClient();
    var trending = Trending(client: client);
    await trending.init();
  });

  test('get360pVideo', () async {
    var api = AndroidVRApi();
    var client = YoutubeClient();

    var watchClient = WatchInfo(client: client);
    await watchClient.initStream("4Hzzdzj-pD4", api: api);
    //print(watchClient.getVideoUrl(VideoCodecType.vp9, Cquality.medium));
  });

  test('get1080pVideoForAndroidVR', () async {
    var api = AndroidVRApi();
    var client = YoutubeClient();

    var watchClient = WatchInfo(client: client);
    await watchClient.initStream("qr1AvisQcV8", api: api);
    //print(watchClient.getVideoUrl(VideoCodecType.vp9, Cquality.hd720));
  });

  test('get4KVideoForAndroidVR', () async {
    var api = AndroidVRApi();
    var client = YoutubeClient();

    var watchClient = WatchInfo(client: client);
    await watchClient.initStream("qr1AvisQcV8", api: api);
    //print(watchClient.getVideoUrl(VideoCodecType.vp9, Cquality.hd2160));
  });

  test('get4KVideoForAndroid', () async {
    var api = AndroidApi();
    var client = YoutubeClient();

    var watchClient = WatchInfo(client: client);
    await watchClient.initStream("qr1AvisQcV8", api: api);
    //print(watchClient.getVideoUrl(VideoCodecType.vp9, Cquality.hd2160));
  });

  test('getOpusAudio', () async {
    var api = IosApi();
    var client = YoutubeClient();

    var watchClient = WatchInfo(client: client);
    await watchClient.initStream("qr1AvisQcV8", api: api);
    //print(watchClient.getAudioUrl(AudioCodecType.opus, Cquality.small));
  });

  test('check search', () async {
    var client = YoutubeClient();
    final page = PageHandler(client: client);
    await page.getPage('search', 'pokemon');
  });

  test('verify channel Extractor', () async {
    var client = YoutubeClient();
    final channel = Channel();
    await channel.init(id: "UCgKkNPU2Ib7_TcyAl8M2S-w", client: client);
  });

  test('getRecommended', () async {
    var client = YoutubeClient();
    final WatchInfo watchInfo = WatchInfo(client: client);
    await watchInfo.initStream('qr1AvisQcV8');
    watchInfo.getRecommendedVideos()[0].title;
  });
}
