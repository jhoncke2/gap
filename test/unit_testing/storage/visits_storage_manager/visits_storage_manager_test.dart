import 'package:flutter_test/flutter_test.dart';
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import 'package:gap/native_connectors/storage_connector.dart';
import '../../../mock/storage/mock_flutter_secure_storage.dart';
import './visits_storage_manager_descriptions.dart' as descriptions;

void main(){
  _initStorageConnector();
  group(descriptions.visitsGroupDescription, (){
    _testSetVisits();
    _testGetVisits();
    _testRemoveVisits();
  });

  group(descriptions.chosenVisitGroupDescription, (){
    _testSetChosenVisit();
    _testGetChosenVisit();
    _testRemoveChosenVisit();
  });
}

void _initStorageConnector(){
  // ignore: invalid_use_of_protected_member
  StorageConnectorSingleton.storageConnector.fss = MockFlutterSecureStorage();
}

void _testSetVisits(){
  test(descriptions.testSetVisitsDescription, ()async{
      await _tryTestSetVisits();

  });
}

Future<void> _tryTestSetVisits()async{
  await VisitsStorageManager.setVisits(fakeData.visits);
}

void _testGetVisits(){
  test(descriptions.testGetVisitsDescription, ()async{   
      await _tryTestGetVisits();

  });
}

Future<void> _tryTestGetVisits()async{
  final List<Visit> visits = await VisitsStorageManager.getVisits();
  _verifyStorageGetReturnedElements(visits);
}

void _verifyStorageGetReturnedElements(List<dynamic> storageReturnedElements){
  expect(storageReturnedElements, isNotNull, reason: 'Las visits retornados por el storageSaver no deben ser null');
  expect(storageReturnedElements.length, fakeData.visits.length, reason: 'El length de las visits retornados por el storageSaver debe ser el mismo que el de los fake');
  for(int i = 0; i < storageReturnedElements.length; i++){
    _compararParDeVisits(storageReturnedElements[i], fakeData.visits[i]);
  }
}

void _compararParDeVisits(Visit v1, Visit v2){
  expect(v1.name, v2.name, reason: 'El name del current visit del storageSaver debe ser el mismo que el de los fakeVisits');
  expect(v1.date, v2.date, reason: 'El date del current visit del storageSaver debe ser el mismo que el de los fakeVisits');
  expect(v1.stage, v2.stage, reason: 'El stage del current visit del storageSaver debe ser el mismo que el de los fakeVisits');
}

void _testRemoveVisits(){
  test(descriptions.testRemoveVisitsDescription, ()async{
      await _tryTestRemoveVisits();

  });
}

Future<void> _tryTestRemoveVisits()async{
  await VisitsStorageManager.removeVisits();
}

void _testSetChosenVisit(){
  test(descriptions.testSetChosenVisitDescription, ()async{   
      await _tryTestSetChosenVisit();

  });
}

Future<void> _tryTestSetChosenVisit()async{
  final Visit chosenOne = fakeData.visits[0];
  await VisitsStorageManager.setChosenVisit(chosenOne);
}

void _testGetChosenVisit(){
  test(descriptions.testGetChosenVisitDescription, ()async{   
      await _tryTestGetChosenVisit();

  });
}

Future<void> _tryTestGetChosenVisit()async{
  final Visit chosenOne = await VisitsStorageManager.getChosenVisit();
  expect(chosenOne, isNotNull, reason: 'El visit retornado por el storage no debería ser null');
  _compararParDeVisits(chosenOne, fakeData.visits[0]);
}

void _testRemoveChosenVisit(){
  test(descriptions.testRemoveChosenVisitDescription, ()async{
      await _tryTestRemoveChosenVisit();

  });
}

Future<void> _tryTestRemoveChosenVisit()async{
  await VisitsStorageManager.removeChosenVisit();
}