import 'package:flutter_test/flutter_test.dart';
import 'package:gap/logic/storage_managers/forms/formularios_storage_manager.dart';
import 'package:gap/native_connectors/storage_connector.dart';

import '../../../mock/storage/mock_flutter_secure_storage.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import './formularios_storage_manager_descriptions.dart' as descriptions;

main(){
  _initStorageConnector();
  group(descriptions.formsGroupDescription, (){
    _testSetForms();
    //_testGetForms();
    //_testRemoveForms();
  });
}

void _initStorageConnector(){
  // ignore: invalid_use_of_protected_member
  StorageConnectorSingleton.storageConnector.fss = MockFlutterSecureStorage();
}

void _testSetForms(){
  test(descriptions.testSetFormsDescription, ()async{
    try{
      await _tryTestSetForms();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestSetForms()async{
  await FormulariosStorageManager.setForms(fakeData.formularios);
}

void _testGetForms(){
  test(descriptions.testGetFormsDescription, ()async{   
    try{
      await _tryTestGetForms();
    }catch(err){
      throw err;
    }
  });
}

Future<void> _tryTestGetForms()async{
  final List<Formulario> visits = await FormulariosStorageManager.getForms();
  _verifyStorageGetReturnedElements(visits);
}

void _verifyStorageGetReturnedElements(List<dynamic> storageReturnedElements){
  expect(storageReturnedElements, isNotNull, reason: 'Las visits retornados por el storageSaver no deben ser null');
  expect(storageReturnedElements.length, fakeData.formularios.length, reason: 'El length de las visits retornados por el storageSaver debe ser el mismo que el de los fake');
  for(int i = 0; i < storageReturnedElements.length; i++){
    _compararParDeForms(storageReturnedElements[i], fakeData.formularios[i]);
  }
}

void _compararParDeForms(Formulario f1, Formulario f2){
  expect(f1.name, f2.name, reason: 'El name del current Form del storageSaver debe ser el mismo que el de los fakeForms');
  expect(f1.date.toString(), f2.date.toString(), reason: 'El date del current Form del storageSaver debe ser el mismo que el de los fakeForms');
  expect(f1.stage, f2.stage, reason: 'El stage del current Form del storageSaver debe ser el mismo que el de los fakeForms');
}

void _testRemoveForms(){
  test(descriptions.testRemoveFormsDescription, ()async{
    try{
      await _tryTestRemoveForms();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemoveForms()async{
  await FormulariosStorageManager.removeForms();
}