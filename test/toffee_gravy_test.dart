import 'package:test/test.dart';
import 'package:toffee_gravy/models/trending.dart';
import 'package:toffee_gravy/utils/utils.dart';

void main() {
  test('trending', () async{
  var trending = TrendingExtractor();
  await trending.init();
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
