import 'dart:convert';

import 'package:flutter_webrtc_demo/model/carebox.dart';
import 'package:http/http.dart' show Client, Response;

class CareboxApiProvider {
  Client client = Client();
  final _baseUrl = "http://172.30.1.19:9090";

  Future<Carebox> fetchStatus() async {
    late Response response;
    try {
      response = await client.get(Uri.parse("$_baseUrl/status"));
    } catch (e) {
      print('CareboxApiProvider exception: ' + e.toString());
    }
    if (response.statusCode == 200) {
      return Carebox.fromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
      throw Exception('Failed to load Carebox');
    }
  }
}
