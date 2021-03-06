import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/storage_managers/visits/preloaded_visits_storage_manager.dart';
import 'package:gap/old_architecture/data/fake_data/fake_data.dart' as fakeData;
import 'visits_storage_manager_descriptions.dart' as descriptions;

final int nVisitsPerProject = 3;

void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  _initStorageConnector();
  group(descriptions.preloadedVisitsGroupDescription, (){
    _testSetPreloadedVisit();
    _testGetPreloadedVisitsByProjectId();
    _testRemovePreloadedVisit();
  });
}

void _initStorageConnector(){
  // ignore: invalid_use_of_protected_member
  //StorageConnectorSingleton.storageConnector.fss = MockFlutterSecureStorage();
}

void _testSetPreloadedVisit(){
  test(descriptions.testRemoveChosenVisitDescription, ()async{
    await _tryTestSetPreloadedVisit();
  });
}

Future<void> _tryTestSetPreloadedVisit()async{
  for(int i = 0; i < fakeData.oldProjects.length; i++){
    final int initialVisitForProjIndex = _getInitialVisitIndexForProjIndex(i);
    for(int j = initialVisitForProjIndex; j < initialVisitForProjIndex + nVisitsPerProject; j++){
      await PreloadedVisitsStorageManager.setVisit(fakeData.visits[j], fakeData.oldProjects[i].id);
    }
    expect(obtainVisitsAsJsonByIndexFromCurrentData(i), isNotNull, reason: 'Las visits by project recientemente agregadas no deben ser null en el currentData del manager');
    expect(obtainVisitsAsJsonByIndexFromCurrentData(i).length, nVisitsPerProject, reason: 'El número de visits del currentData debe ser el mismo que se agregó');
  }
}

List<Map<String, dynamic>> obtainVisitsAsJsonByIndexFromCurrentData(int index){
  return PreloadedVisitsStorageManager.currentPreloadedVisitsHolder.currentData[fakeData.oldProjects[index].id.toString()]??[ ];
}

void _testGetPreloadedVisitsByProjectId(){
  test(descriptions.testRemoveChosenVisitDescription, ()async{
    await _tryTestGetPreloadedVisitsByProjectId();
  });
}

Future<void> _tryTestGetPreloadedVisitsByProjectId()async{
  for(int i = 0; i < fakeData.oldProjects.length; i++){
    final int initialVisitForProjIndex = _getInitialVisitIndexForProjIndex(i);
    final List<VisitOld> visitsByProjectId = await PreloadedVisitsStorageManager.getVisitsByProjectId(fakeData.oldProjects[i].id);
    for(int j = 0; j < visitsByProjectId.length; j++){
      expect(visitsByProjectId.length, nVisitsPerProject, reason: 'El length de las visits del projectId actual debe ser igual al estipulado por el test');
      expect(jsonEncode(visitsByProjectId[j]), jsonEncode(fakeData.visits[initialVisitForProjIndex + j]), reason: 'Las visits retornadas por el getVisitByProjectId deben venir en agrupadas y en el mismo orden como se agregaron');
    }
  }
}

int _getInitialVisitIndexForProjIndex(int projIndex){
  return projIndex*nVisitsPerProject;
}

void _testRemovePreloadedVisit(){
  test(descriptions.testRemoveChosenVisitDescription, ()async{
    try{
      await _tryTestRemovePreloadedVisit();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemovePreloadedVisit()async{
  for(int i = 0; i < fakeData.oldProjects.length; i++){
    final int initialVisitForProjIndex = _getInitialVisitIndexForProjIndex(i);
    for(int j = initialVisitForProjIndex; j < initialVisitForProjIndex + nVisitsPerProject; j++){
       await PreloadedVisitsStorageManager.removeVisit(fakeData.visits[j].id, fakeData.oldProjects[i].id);
       final int jIndexFromZero = j - initialVisitForProjIndex;
       final int expectedVisitsByProjectIdLength = nVisitsPerProject - jIndexFromZero - 1;
       expect(obtainVisitsAsJsonByIndexFromCurrentData(fakeData.oldProjects[i].id).length, expectedVisitsByProjectIdLength, reason: 'El length de las visitas con el projectId actual debería haber disminuido en 1');
    }
  }
}

void _testSetCurrentPreloadedVisitsByChosenProject(){
  test(descriptions.testRemoveChosenVisitDescription, ()async{
    try{
      await _tryTestSetCurrentPreloadedVisitsByChosenProject();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestSetCurrentPreloadedVisitsByChosenProject()async{

}