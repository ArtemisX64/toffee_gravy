import 'package:test/test.dart';
import 'package:toffee_gravy/model/codecs/caudio.dart';
import 'package:toffee_gravy/model/codecs/cmuxed.dart';
import 'package:toffee_gravy/pages/trending.dart';
import 'package:toffee_gravy/reverse/youtube/internal/api.dart';
import 'package:toffee_gravy/reverse/youtube/internal/stream/stream_handler.dart';
import 'package:toffee_gravy/reverse/youtube/youtube_client_handler.dart';
import 'package:toffee_gravy/utils/utils.dart';

void main() {
  test('trending', () async{
  var trending = TrendingExtractor();
  await trending.init();
  });

  test ('get360pVideo', () async {
    var api = IosApi();
    var client = YoutubeClient();

    var youtubeVideoExtractor = StreamHandler(client, api);
    final stream = await youtubeVideoExtractor.getStream("4Hzzdzj-pD4");
    stream.streamUrls!.forEach((key, value) {
      if (key is MuxedCodec && key.quality == MuxedQualityType.q360){
        // print(key.codec.codec);
        // print(value);
      }
    });

    


  });

  test ('getOpusAudio', () async {
    var api = IosApi();
    var client = YoutubeClient();

    var youtubeVideoExtractor = StreamHandler(client, api);
    final stream = await youtubeVideoExtractor.getStream("4Hzzdzj-pD4");
    stream.streamUrls!.forEach((key, value) {
      if(key is AudioCodec && key.codec == AudioCodecType.opus){
        // print(value);
      }
    });
   


  });
   test('trending with country code', () async{
  var trending = TrendingExtractor(countryCode: CountryCode(country: Country.japan));
  await trending.init();
  });

   test('trending dynamic change country', () async{
  var trending = TrendingExtractor();
  final country = CountryCode(country: Country.japan);
    await trending.init();
  await trending.refreshListWithNewCountry(country);
  });

  
}
