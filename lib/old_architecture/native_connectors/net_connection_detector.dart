import 'package:connectivity/connectivity.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';


class NetConnectionDetector{
  static final NetConnectionStateContainer netConnectionStateContainer = NetConnectionStateContainer();
  static final Connectivity _connectivity = Connectivity();

  static Future initCurrentNavConnectionState()async{
    netConnectionStateContainer.currentState = await netConnectionState;
  }

  static Future<NetConnectionState> get netConnectionState async{
    final ConnectivityResult connResult = await _connectivity.checkConnectivity();
    return _getNetConnectionStateFromConnectivityResult(connResult);
  }

  static set onConnectionChange(Function(NetConnectionState) function){
    _connectivity.onConnectivityChanged.listen((ConnectivityResult newResult) {
      final NetConnectionState newNetConnState = _getNetConnectionStateFromConnectivityResult(newResult);
      _doOnConnChangeFunctionIfStateReallyChanged(function, newNetConnState);
    });
  }

  static void _doOnConnChangeFunctionIfStateReallyChanged(Function function, NetConnectionState newNetConnState){
    if(newNetConnState != netConnectionStateContainer.currentState){
      _doOnConnChangeFunction(function, newNetConnState);
    }
  }

  static void _doOnConnChangeFunction(Function function, NetConnectionState newNetConnState){
    netConnectionStateContainer.currentState = newNetConnState;
    function(newNetConnState);
  }

  static NetConnectionState _getNetConnectionStateFromConnectivityResult(ConnectivityResult result){
    if([ConnectivityResult.mobile, ConnectivityResult.wifi].contains(result))
      return NetConnectionState.Connected;
    else
      return NetConnectionState.Disonnected;
  }
}

class NetConnectionStateContainer{
  NetConnectionState currentState;
}