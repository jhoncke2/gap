import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/native_connectors/net_connection_detector.dart';

main(){
  WidgetsFlutterBinding.ensureInitialized();
  _testGetConnectionState();
}

void _testGetConnectionState(){
  test('probando método get connection state', (){
    try{
      _tryTestGetConnectionState();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestGetConnectionState()async{
  final NetConnectionState connState = await NetConnectionDetector.netConnectionState;
  expect(connState, isNotNull, reason: 'El connection state no debe ser null');
  expect(connState, NetConnectionState.Connected, reason: 'El estado debe ser conectado');
}