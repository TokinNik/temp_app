import 'package:connectivity/connectivity.dart';

Future<bool> checkConnection() async {
  var result = await (Connectivity().checkConnectivity());
  return result != ConnectivityResult.none;
}
