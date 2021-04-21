import 'package:flutter_test/flutter_test.dart';
import 'package:gap/old_architecture/logic/storage_managers/forms/chosen_form_storage_manager.dart';

import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/data/fake_data/fake_data.dart' as fakeData;
import 'chosen_form_storage_manager_descriptions.dart' as descriptions;

/*
main(){
  _initStorageConnector();
  group(descriptions.chosenFormGroupDescription, (){
    _testSetChosenVisit();
    _testGetChosenVisit();
    _testRemoveChosenVisit();
  });
}
*/

void _initStorageConnector(){
  // ignore: invalid_use_of_protected_member
  //StorageConnectorSingleton.storageConnector.fss = MockFlutterSecureStorage();
}

void _testSetChosenVisit(){
  test(descriptions.testSetChosenFormDescription, ()async{   
      await _tryTestSetChosenVisit();

  });
}

Future<void> _tryTestSetChosenVisit()async{
  final FormularioOld chosenOne = fakeData.formularios[0];
  await ChosenFormStorageManager.setChosenForm(chosenOne);
}

void _testGetChosenVisit(){
  test(descriptions.testGetChosenFormDescription, ()async{   
      await _tryTestGetChosenVisit();

  });
}

Future<void> _tryTestGetChosenVisit()async{
  final FormularioOld chosenOne = await ChosenFormStorageManager.getChosenForm();
  expect(chosenOne, isNotNull, reason: 'El visit retornado por el storage no debería ser null');
  _compararParDeForms(chosenOne, fakeData.formularios[0]);
}

void _compararParDeForms(FormularioOld f1, FormularioOld f2){
  expect(f1.name, f2.name, reason: 'El name del current Form del storageSaver debe ser el mismo que el del fakeForm');
  //expect(f1.date.toString(), f2.date.toString(), reason: 'El date del current Form del storageSaver debe ser el mismo que el del fakeForm');
  expect(f1.stage, f2.stage, reason: 'El stage del current Form del storageSaver debe ser el mismo que el del fakeForm');
}

void _testRemoveChosenVisit(){
  test(descriptions.testRemoveChosenFormDescription, ()async{
      await _tryTestRemoveChosenVisit();

  });
}

Future<void> _tryTestRemoveChosenVisit()async{
  await ChosenFormStorageManager.removeChosenForm();
}