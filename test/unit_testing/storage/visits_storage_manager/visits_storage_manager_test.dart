import 'package:flutter_test/flutter_test.dart';
import 'package:gap/logic/bloc/entities/visits/visits_storage_manager.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import '../../../mock/mock_storage_manager.dart';
import './visits_storage_manager_descriptions.dart' as descriptions;

final VisitsStorageManager visitsSM = VisitsStorageManager.forTesting(storageConnector: MockStorageConnector());

void main(){
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

void _testSetVisits(){
  test(descriptions.testSetVisitsDescription, ()async{
    try{
      await _tryTestSetVisits();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestSetVisits()async{
  await visitsSM.setVisits(fakeData.visits);
}

void _testGetVisits(){
  test(descriptions.testGetVisitsDescription, ()async{   
    try{
      await _tryTestGetVisits();
    }catch(err){
      throw err;
    }
  });
}

Future<void> _tryTestGetVisits()async{
  final List<Visit> visits = await visitsSM.getVisits();
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
    try{
      await _tryTestRemoveVisits();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemoveVisits()async{
  await visitsSM.deleteVisits();
}

void _testSetChosenVisit(){
  test(descriptions.testSetChosenVisitDescription, ()async{   
    try{
      await _tryTestSetChosenVisit();
    }catch(err){
      throw err;
    }
  });
}

Future<void> _tryTestSetChosenVisit()async{
  final Visit chosenOne = fakeData.visits[0];
  await visitsSM.setChosenVisit(chosenOne);
}

void _testGetChosenVisit(){
  test(descriptions.testGetChosenVisitDescription, ()async{   
    try{
      await _tryTestGetChosenVisit();
    }catch(err){
      throw err;
    }
  });
}

Future<void> _tryTestGetChosenVisit()async{
  final Visit chosenOne = await visitsSM.getChosenVisit();
  expect(chosenOne, isNotNull, reason: 'El visit retornado por el storage no debería ser null');
  _compararParDeVisits(chosenOne, fakeData.visits[0]);
}

void _testRemoveChosenVisit(){
  test(descriptions.testRemoveChosenVisitDescription, ()async{
    try{
      await _tryTestRemoveChosenVisit();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemoveChosenVisit()async{
  await visitsSM.removeChosenVisit();
}