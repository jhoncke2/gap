import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/preloaded_forms_storage_manager.dart';
import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import 'package:gap/native_connectors/storage_connector.dart';
import '../../../mock/storage/mock_flutter_secure_storage.dart';
import './formularios_storage_manager_descriptions.dart' as descriptions;

final int nFormsPerVisit = 2;

void main(){
  _initStorageConnector();
  group(descriptions.preloadedFormsGroupDescription, (){
    _testSetPreloadedForm();
    _testGetPreloadedVisitsByProjectId();
    //_testRemovePreloadedVisit();
  });
}

void _initStorageConnector(){
  // ignore: invalid_use_of_protected_member
  StorageConnectorSingleton.storageConnector.fss = MockFlutterSecureStorage();
}

void _testSetPreloadedForm(){
  test(descriptions.testSePreloadedFormsDescription, ()async{
    await _tryTestSetPreloadedForm();

  });
}

Future<void> _tryTestSetPreloadedForm()async{
  for(int i = 0; i < fakeData.projects.length; i++){
    final int initialVisitForProjIndex = _getInitialFormIndexForVisitIndex(i);
    for(int j = initialVisitForProjIndex; j < initialVisitForProjIndex + nFormsPerVisit; j++){
      await PreloadedFormsStorageManager.setPreloadedForm(fakeData.formularios[j], fakeData.projects[i].id);
    }
    expect(obtainFormsAsJsonByIndexFromCurrentData(i), isNotNull, reason: 'Las Forms by project recientemente agregadas no deben ser null en el currentData del manager');
    expect(obtainFormsAsJsonByIndexFromCurrentData(i).length, nFormsPerVisit, reason: 'El número de Forms del currentData debe ser el mismo que se agregó');
  }
}

List<Map<String, dynamic>> obtainFormsAsJsonByIndexFromCurrentData(int index){
  return PreloadedFormsStorageManager.currentPreloadedFormsHolder.currentData[fakeData.projects[index].id.toString()]??[ ];
}

void _testGetPreloadedVisitsByProjectId(){
  test(descriptions.testGetPreloadedFormsDescription, ()async{
    await _tryTestGetPreloadedVisitsByProjectId();
  });
}

Future<void> _tryTestGetPreloadedVisitsByProjectId()async{
  for(int i = 0; i < fakeData.visits.length; i++){
    final int initialFormForVisitIndex = _getInitialFormIndexForVisitIndex(i);
    final List<Formulario> formsByVisitId = await PreloadedFormsStorageManager.getPreloadedFormsByVisitId(fakeData.visits[i].id);
    for(int j = 0; j < formsByVisitId.length; j++){
      expect(formsByVisitId.length, nFormsPerVisit, reason: 'El length de los Forms del Visit Id actual debe ser igual al estipulado por el test');
      expect(jsonEncode(formsByVisitId[j]), jsonEncode(fakeData.formularios[initialFormForVisitIndex + j]), reason: 'Los Forms retornadas por el getVisitByVisit Id deben venir en agrupadas y en el mismo orden como se agregaron');
    }
  }
}

int _getInitialFormIndexForVisitIndex(int projIndex){
  return projIndex*nFormsPerVisit;
}

void _testRemovePreloadedVisit(){
  test(descriptions.testRemovePreloadedFormsDescription, ()async{
    try{
      await _tryTestRemovePreloadedVisit();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemovePreloadedVisit()async{
  for(int i = 0; i < fakeData.projects.length; i++){
    final int initialVisitForProjIndex = _getInitialFormIndexForVisitIndex(i);
    for(int j = initialVisitForProjIndex; j < initialVisitForProjIndex + nFormsPerVisit; j++){
       await PreloadedFormsStorageManager.removePreloadedForm(fakeData.visits[j].id, fakeData.projects[i].id);
       final int jIndexFromZero = j - initialVisitForProjIndex;
       final int expectedVisitsByProjectIdLength = nFormsPerVisit - jIndexFromZero - 1;
       expect(obtainFormsAsJsonByIndexFromCurrentData(fakeData.projects[i].id).length, expectedVisitsByProjectIdLength, reason: 'El length de las visitas con el projectId actual debería haber disminuido en 1');
    }
  }
}