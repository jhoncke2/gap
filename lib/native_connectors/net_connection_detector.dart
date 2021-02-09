import 'package:connectivity/connectivity.dart';
import 'package:gap/data/enums/enums.dart';


class NetConnectionDetector{
  static final Connectivity _connectivity = Connectivity();

  static Future<NetConnectionState> get netConnectionState async{
    final ConnectivityResult connResult = await _connectivity.checkConnectivity();
    return _getNetConnectionStateFromConnectivityResult(connResult);
  }

  static set onConnectionChange(Function(NetConnectionState) function){
    _connectivity.onConnectivityChanged.listen((ConnectivityResult newResult) {
      final NetConnectionState netConnState = _getNetConnectionStateFromConnectivityResult(newResult);
      function(netConnState);
    });
  }

  static NetConnectionState _getNetConnectionStateFromConnectivityResult(ConnectivityResult result){
    if([ConnectivityResult.mobile, ConnectivityResult.wifi].contains(result))
      return NetConnectionState.Connected;
    else
      return NetConnectionState.Disonnected;
  }
}