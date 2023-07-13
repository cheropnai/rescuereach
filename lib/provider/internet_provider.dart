import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

class InternetProvider extends ChangeNotifier {
  bool _hasInternet = false;
  bool get hasInternet => _hasInternet;
  InternetProvider() {
    checkInternetConnection();
  }
  Future checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _hasInternet = false;
    } else {
      _hasInternet = true;
    }
  }

  @override
  notifyListeners();
}