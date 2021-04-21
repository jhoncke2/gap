import 'package:meta/meta.dart';
import 'package:connectivity/connectivity.dart';

abstract class NetworkInfo{
  Future<bool> isConnected();
  void onConnectivityChanged(Function(bool) function);
}

class NetworkInfoImpl implements NetworkInfo{
  final Connectivity connectivity;
  ConnectivityResult currentConnResult;

  NetworkInfoImpl({
    @required this.connectivity
  });

  @override
  Future<bool> isConnected()async{
    final result = await connectivity.checkConnectivity();
    if([ConnectivityResult.wifi, ConnectivityResult.mobile].contains(result))
      return true;
    else
      return false;
  }

  void onConnectivityChanged(Function(bool) function){
    connectivity.onConnectivityChanged.listen((ConnectivityResult newResult){
      if(newResult != currentConnResult)
        _doOnConnChangeFunction(function, newResult);
    });
  }

  void _doOnConnChangeFunction(Function function, ConnectivityResult newConnectivityResult){
    currentConnResult = newConnectivityResult;
    function(newConnectivityResult);
  }
}