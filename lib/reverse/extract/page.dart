import 'package:toffee_gravy/utils/exceptions.dart';

abstract class Page{
  
  dynamic page;
  String fetchHTMLPage();

  void getJsonFromEntry(String entry) {
    final document = fetchHTMLPage();
    final regex = RegExp('$entry\\s*(\\{.*?\\});');
    final jsonRegex = regex.firstMatch(document);
    if (jsonRegex == null){
      throw BitterToffee("Couldn't find any matching Json Entry");
    }

    print(jsonRegex.groupNames);
  }
  


}