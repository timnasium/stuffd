import 'package:http/http.dart';



Future<Response> httpGet(Uri url) async {
//TODO: add auth or other stuff like error handling
  var r = await get(url);

  return r;
}
