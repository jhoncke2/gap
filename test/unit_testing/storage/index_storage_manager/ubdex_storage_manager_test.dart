import 'package:flutter_test/flutter_test.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/storage_managers/index/index_storage_manager.dart';
import 'package:gap/native_connectors/storage_connector.dart';

import '../../../mock/storage/mock_flutter_secure_storage.dart';
import './index_storage_manager_descriptions.dart' as descriptions;

final IndexState fakeIndexState = IndexState(
  nPages: 3,
  currentIndexPage: 1,
  sePuedeAvanzar: false,
  sePuedeRetroceder: true
);

main(){

  _initStorageConnector();
  group(descriptions.indexGroupDescription, (){
    _testSetIndex();
    _testGetIndex();
    _testRemoveIndex();
  });
}

void _initStorageConnector(){
  // ignore: invalid_use_of_protected_member
  StorageConnectorSingleton.storageConnector.fss = MockFlutterSecureStorage();
}

void _testSetIndex(){
  test(descriptions.testSeIndexsDescription, ()async{
    try{
      await _tryTestSetIndex();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestSetIndex()async{
  await IndexStorageManager.setIndex(fakeIndexState);
}

void _testGetIndex(){
  test(descriptions.testGetIndexDescription, ()async{   
    try{
      await _tryTestGetIndex();
    }catch(err){
      throw err;
    }
  });
}

Future<void> _tryTestGetIndex()async{
  final IndexState indexState = await IndexStorageManager.getIndex();
  expect(indexState.nPages, fakeIndexState.nPages, reason: 'El número de páginas debe ser al mismo del del fake');
  expect(indexState.currentIndexPage, fakeIndexState.currentIndexPage, reason: 'El currentIndexPage debe ser al mismo del del fake');
  expect(indexState.sePuedeAvanzar, fakeIndexState.sePuedeAvanzar, reason: 'El sePuedeAvanzar debe ser al mismo del del fake');
  expect(indexState.sePuedeRetroceder, fakeIndexState.sePuedeRetroceder, reason: 'El sePuedeRetroceder debe ser al mismo del del fake');
}

void _testRemoveIndex(){
  test(descriptions.testRemoveIndexDescription, ()async{
    try{
      await _tryTestRemoveCommentedImages();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemoveCommentedImages()async{
  await IndexStorageManager.removeIndex();
  final IndexState indexState = await IndexStorageManager.getIndex();
  expect(indexState.nPages, 0, reason: 'Se acabó de borrar el index del storage. El nPage debe ser 0');
  expect(indexState.currentIndexPage, -1, reason: 'Se acabó de borrar el index del storage. El currentIndexPage debe ser -1');
  expect(indexState.sePuedeAvanzar, false, reason: 'Se acabó de borrar el index del storage. El sePuedeAvanzar debe ser false');
  expect(indexState.sePuedeRetroceder, false, reason: 'Se acabó de borrar el index del storage. El sePuedeRetroceder debe ser false');
}