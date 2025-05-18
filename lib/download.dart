import 'package:http/http.dart';

mixin Download {
  Future<Response> download(String link) async{
    var client = Client();
    Response response = await client.get(Uri.parse(link));
    return response;
  }
}