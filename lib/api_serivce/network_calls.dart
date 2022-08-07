import 'dart:io';

import 'package:http/http.dart';

final client = Client();

class NetworkCalls {
  Future<String> get(String url, Map<String, String>? header) async {
    return await client.get(Uri.parse(url), headers: header).then((response) {
      return response.body;
    });

    // .onError((error, stackTrace) {
    //   print(">>>>>>>>> error >>>>> ${error}");
    //   return "{}";
    // });
  }

  Future<String> post(String url, var body, Map<String, String>? header) async {
    var response =
        await client.post(Uri.parse(url), body: body, headers: header);

    // checkAndThrowError(response);
    return response.body;
  }

  Future<String> put(String url, var body, Map<String, String>? header) async {
    var response =
        await client.put(Uri.parse(url), body: body, headers: header);

    checkAndThrowError(response);
    return response.body;
  }

  static void checkAndThrowError(Response response) {
    if (response.statusCode != HttpStatus.ok) throw Exception(response.body);
  }
}
