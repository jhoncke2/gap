import 'package:flutter_test/flutter_test.dart';
import 'package:gap/logic/storage_managers/forms/chosen_form_storage_manager.dart';
import 'package:gap/native_connectors/storage_connector.dart';

import '../../../mock/storage/mock_flutter_secure_storage.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import './chosen_form_storage_manager_descriptions.dart' as descriptions;

main(){
  _initStorageConnector();
  group(descriptions.chosenFormGroupDescription, (){
    _testSetChosenVisit();
    _testGetChosenVisit();
    _testRemoveChosenVisit();
  });
}

void _initStorageConnector(){
  // ignore: invalid_use_of_protected_member
  StorageConnectorSingleton.storageConnector.fss = MockFlutterSecureStorage();
}

void _testSetChosenVisit(){
  test(descriptions.testSetChosenFormDescription, ()async{   
    try{
      await _tryTestSetChosenVisit();
    }catch(err){
      throw err;
    }
  });
}

Future<void> _tryTestSetChosenVisit()async{
  final Formulario chosenOne = fakeData.formularios[0];
  await ChosenFormStorageManager.setChosenForm(chosenOne);
}

void _testGetChosenVisit(){
  test(descriptions.testGetChosenFormDescription, ()async{   
    try{
      await _tryTestGetChosenVisit();
    }catch(err){
      throw err;
    }
  });
}

Future<void> _tryTestGetChosenVisit()async{
  final Formulario chosenOne = await ChosenFormStorageManager.getChosenForm();
  expect(chosenOne, isNotNull, reason: 'El visit retornado por el storage no debería ser null');
  _compararParDeForms(chosenOne, fakeData.formularios[0]);
}

void _compararParDeForms(Formulario f1, Formulario f2){
  expect(f1.name, f2.name, reason: 'El name del current Form del storageSaver debe ser el mismo que el del fakeForm');
  expect(f1.date.toString(), f2.date.toString(), reason: 'El date del current Form del storageSaver debe ser el mismo que el del fakeForm');
  expect(f1.stage, f2.stage, reason: 'El stage del current Form del storageSaver debe ser el mismo que el del fakeForm');
}

void _testRemoveChosenVisit(){
  test(descriptions.testRemoveChosenFormDescription, ()async{
    try{
      await _tryTestRemoveChosenVisit();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemoveChosenVisit()async{
  await ChosenFormStorageManager.removeChosenForm();
}