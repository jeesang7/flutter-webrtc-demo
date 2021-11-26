import 'package:flutter_webrtc_demo/model/carebox.dart';
import 'package:flutter_webrtc_demo/resource/repository.dart';
import 'package:rxdart/rxdart.dart';

class CareboxBloc {
  final _repository = Repository();
  final _careboxFetcher = PublishSubject<Carebox>();

  Stream<Carebox> get status => _careboxFetcher.stream;

  fetchStatus() async {
    Carebox carebox = await _repository.fetchStatus();
    _careboxFetcher.sink.add(carebox);
  }

  dispose() {
    _careboxFetcher.close();
  }
}

final bloc = CareboxBloc();
