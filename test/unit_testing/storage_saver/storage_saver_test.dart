import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import '../../mock/mock_storage_saver.dart';
import 'storage_saver_tests_descriptions.dart' as descriptions;

final MockStorageSaver storageSaver = MockStorageSaver();

final String initialResourceKey = 'fake_initial_resource_key';
final String initialResourceValue = 'fake_initial_resource_value';
final String stringResourceKey = 'string_resource_key';
final String stringResourceValue = 'string_resource_value';
final String mapResourceKey = 'map_resource_key';
final Map<String, dynamic> mapResourceValue = {'k1':'v1', 'k2':2, 'k3':true};
final String listResourceKey = 'list_resource_key';
final List<Map<String, dynamic>> listResourceValue = [
  {'k1':'v1', 'k2':2, 'k3':true},
  {'k1':'v2', 'k2':-3, 'k3':false}
];

main(){
  _initStorageFakeInitialElement();
  _testRemove();
  group(descriptions.setGetStringGroupDescription, (){
    _testSetString();
    _testGetString();
  });

  group(descriptions.setGetMapGroupDescription, (){
    _testSetMap();
    _testGetMap();
  });

  group(descriptions.setGetListGroupDescription, (){
    _testSetList();
    _testGetList();
  });
}

void _initStorageFakeInitialElement(){
  storageSaver.storage[initialResourceKey] = initialResourceValue;
}

void _testRemove(){
  test(descriptions.testRemoveDescription, ()async{
    try{
      await _tryTestRemove();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemove()async{
  expect(storageSaver.storage[initialResourceKey], isNotNull, reason: 'El recurso inicial debe existir antes de intentar borrarlo.');
  await storageSaver.removeResource(initialResourceKey);
  expect(storageSaver.storage[initialResourceKey], isNull, reason: 'Después de borrar el recurso, este debería no existir en el storage');
}

void _testSetString(){
  test(descriptions.testSetStringDescription, ()async{
    try{
      await _tryTestSetString();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestSetString()async{
   await storageSaver.setStringResource(stringResourceKey, stringResourceValue);
   final String storageResource = storageSaver.storage[stringResourceKey];
   _verifyResourceIsntNull(storageResource);
   _verifyStringResourceIsEqualsToFake(storageResource);
}

void _testGetString(){
  test(descriptions.testGetStringDescription, ()async{
    try{
      await _tryTestGetString();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestGetString()async{
  final String returnedResource = await storageSaver.getStringResource(stringResourceKey);
  _verifyResourceIsntNull(returnedResource);
  _verifyStringResourceIsEqualsToFake(returnedResource);
}

void _verifyStringResourceIsEqualsToFake(String stringResource){
  expect(stringResource, stringResourceValue, reason: 'El campo $stringResourceKey en el storageSaver debe ser igual al valor fake del test');
}

void _testSetMap(){
  test(descriptions.testSetMapDescription, ()async{
    try{
      await _tryTestSetMap();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestSetMap()async{
   await storageSaver.setMapResource(mapResourceKey, mapResourceValue);
   final Map<String, dynamic> storageResource = jsonDecode(storageSaver.storage[mapResourceKey]);
   _verifyResourceIsntNull(storageResource);
   _verifyMapResourceIsEqualsToFake(storageResource);
}

void _testGetMap(){
  test(descriptions.testGetMapDescription, ()async{
    try{
      await _tryTestGetMap();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestGetMap()async{
  final Map<String, dynamic> returnedResource = await storageSaver.getMapResource(mapResourceKey);
  _verifyResourceIsntNull(returnedResource);
  _verifyMapResourceIsEqualsToFake(returnedResource);
}

void _verifyMapResourceIsEqualsToFake(Map<String, dynamic> mapResource){
  expect(mapResource, mapResourceValue, reason: 'El campo $stringResourceKey en el storageSaver debe ser igual al valor fake del test');
}

void _testSetList(){
  test(descriptions.testSetMapDescription, ()async{
    try{
      await _tryTestSetList();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestSetList()async{
   await storageSaver.setListResource(mapResourceKey, listResourceValue);
   final List<Map<String, dynamic>> storageResource = jsonDecode(storageSaver.storage[mapResourceKey]).cast<Map<String, dynamic>>();
   _verifyResourceIsntNull(storageResource);
   _verifyListResourceIsEqualsToFake(storageResource);
}

void _testGetList(){
  test(descriptions.testGetMapDescription, ()async{
    try{
      await _tryTestGetList();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestGetList()async{
  final List<Map<String, dynamic>> returnedResource = await storageSaver.getListResource(mapResourceKey);
  _verifyResourceIsntNull(returnedResource);
  _verifyListResourceIsEqualsToFake(returnedResource);
}

void _verifyListResourceIsEqualsToFake(List<Map<String, dynamic>> listResource){
  expect(listResource.length, listResourceValue.length, reason: 'El listResource retornado por el storage debe tener el mismo tamaño que el fake list resource del test');
  for(int i = 0; i < listResource.length; i++){
    expect(listResource[i], listResourceValue[i], reason: 'El elemento actual del listResource retornado por el storage debe ser el mismo que el elemento actual del fake list resource del test');
  }

}







void _verifyResourceIsntNull(dynamic resource){
  expect(resource, isNotNull, reason: 'El campo $stringResourceKey en el storageSaver no debe ser null');
}