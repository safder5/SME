import 'dart:async';

import 'package:connectivity/connectivity.dart';

class NetworkService {
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  NetworkService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      bool isConnected = result != ConnectivityResult.none;
      _connectionStatusController.add(isConnected);
    });
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
