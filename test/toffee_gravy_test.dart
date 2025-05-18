import 'package:toffee_gravy/toffee_gravy.dart';
import 'package:test/test.dart';
import 'package:toffee_gravy/models/trending.dart';

void main() {
  test('calculate', () {
    expect(calculate(), 42);
  });

  test('first', () async{
  var trending = TrendingExtractor();
  await trending.init();
  });
  
}
