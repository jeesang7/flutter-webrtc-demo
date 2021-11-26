import 'package:flutter_webrtc_demo/model/carebox.dart';
import 'carebox_api_provider.dart';

class Repository {
  final careboxApiProvider = CareboxApiProvider();

  Future<Carebox> fetchStatus() => careboxApiProvider.fetchStatus();
}
