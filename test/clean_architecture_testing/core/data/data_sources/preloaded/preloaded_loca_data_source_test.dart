import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded/preloaded_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestreo_model.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockStorageConnector extends Mock implements StorageConnector{}

PreloadedLocalDataSourceImpl preloadedLocalDataSource;
MockStorageConnector storageConnector;

void main(){
  setUp((){
    storageConnector = MockStorageConnector();
    preloadedLocalDataSource = PreloadedLocalDataSourceImpl(storageConnector: storageConnector);
  });
  _testSetPreloadedFamilyGroup();
  _testGetPreloadedProjectsIdsGroup();
  _testGetPreloadedVisitsIdsGroup();
  _testGetPreloadedFormulariosGroup();
  _testUpdatePreloadedFormularioGroup();
  _testRemovePreloadedFormularioGroup();
  _testDeleteAllGroup();
}

void _testSetPreloadedFamilyGroup(){

  group('setPreloadedFamily', (){
    int tPreloadedProjectId;
    int tPreloadedVisitId1;
    List<FormularioModel> tFormularios;
    Map<String, dynamic> tEmptyPreloadedData;
    Map<String, dynamic> tPreloaded1Project1VisitAllForms;
    MuestreoModel tMuestreo;

    setUp((){
      tPreloadedProjectId = 1;
      tPreloadedVisitId1 = 2;
      tFormularios = _getFormulariosFromFixtures();
      tMuestreo = _getMuestreoFromFixtures();
      tEmptyPreloadedData = {};
      tPreloaded1Project1VisitAllForms = {
        '$tPreloadedProjectId': {
          '$tPreloadedVisitId1': {
            'formularios': formulariosToJson(tFormularios),
            'muestreo': tMuestreo.toJson()
          }
        }
      };
    });

    test('should add all to the storageConnector when all goes good and there is not preloaded data', ()async{
      when(storageConnector.getMap(any)).thenAnswer((_) async => tEmptyPreloadedData);
      await preloadedLocalDataSource.setPreloadedFamily(tPreloadedProjectId, tPreloadedVisitId1, tFormularios, tMuestreo);
      verify(storageConnector.getMap(PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
      verify(storageConnector.setMap(tPreloaded1Project1VisitAllForms, PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
    });
  });
}

List<FormularioModel> _getFormulariosFromFixtures(){
  final String stringProjects = callFixture('formularios.json');
  final List<Map<String, dynamic>> jsonProjects = jsonDecode(stringProjects).cast<Map<String, dynamic>>();
  return formulariosFromJson(jsonProjects);
}

void _testGetPreloadedProjectsIdsGroup(){
  group('getPreloadedProjectsIds', (){
    List<int> tProjectsIds;
    List<int> tCleanedProjectsIds;
    Map<String, dynamic> tPreloaded4ProjectsData;

    setUp((){
      tProjectsIds = [1,2,3,4];
      tCleanedProjectsIds = [tProjectsIds[0],tProjectsIds[1]];
      tPreloaded4ProjectsData = {
        '${tProjectsIds[0]}':{'1':[]},
        '${tProjectsIds[1]}':{'2':[], '3':[]},
        '${tProjectsIds[2]}':{},
        '${tProjectsIds[3]}':{}
      };
    });

    test('should get the preloaded projects ids successfuly', ()async{
      when(storageConnector.getMap(any)).thenAnswer((realInvocation) async => tPreloaded4ProjectsData);
      final List<int> preloadedProjectsIds = await preloadedLocalDataSource.getPreloadedProjectsIds();
      verify(storageConnector.getMap(PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
      expect(preloadedProjectsIds, tCleanedProjectsIds);
    });
  });
}

void _testGetPreloadedVisitsIdsGroup(){
  group('getPreloadedVisitsIds', (){
    List<int> tProjectsIds;
    List<int> tVisitsIdsP1;
    List<int> tCleanedVisitsIdsP1;
    List<int> tVisitsIdsP2;
    List<int> tCleanedVisitsIdsP2;
    Map<String, dynamic> tPreloaded2Projects3VisitsData;
    FormularioModel tFormulario;
    setUp((){
      tProjectsIds = [1,2];
      tVisitsIdsP1 = [1];
      tVisitsIdsP2 = [1,2,3];
      tCleanedVisitsIdsP2 = [tVisitsIdsP2[0], tVisitsIdsP2[1]];
      tFormulario = _getFormulariosFromFixtures()[0];
      tPreloaded2Projects3VisitsData = {
        '${tProjectsIds[0]}':{'${tVisitsIdsP1[0]}':[]},
        '${tProjectsIds[1]}':{
          '${tVisitsIdsP2[0]}':[tFormulario], 
          '${tVisitsIdsP2[1]}':[tFormulario],
          '${tVisitsIdsP2[2]}':[]
        },
      };
    });

    test('should get the preloaded visits ids successfuly', ()async{
      when(storageConnector.getMap(any)).thenAnswer((realInvocation) async => tPreloaded2Projects3VisitsData );
      List<int> visitsIds = await preloadedLocalDataSource.getPreloadedVisitsIds(tProjectsIds[1]);
      verify(storageConnector.getMap(PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
      visitsIds = await preloadedLocalDataSource.getPreloadedVisitsIds(tProjectsIds[1]);
      expect(visitsIds, tCleanedVisitsIdsP2);
    });
  });
}

void _testGetPreloadedFormulariosGroup(){
  group('getPreloadedFormularios', (){
    List<int> tProjectsIds;
    List<int> tVisitsIdsP1;
    List<int> tVisitsIdsP2;
    List<FormularioModel> tFormulariosP2V2;
    List<FormularioModel> tFormulariosP2V3;
    Map<String, dynamic> tPreloaded2Projects3VisitsData2FormsData;

    setUp((){
      tProjectsIds = [1,2];
      tVisitsIdsP1 = [1];
      tVisitsIdsP2 = [1,2,3];
      tFormulariosP2V2 = _getFormulariosFromFixtures();
      tFormulariosP2V3 = [tFormulariosP2V2[0]];
      tPreloaded2Projects3VisitsData2FormsData = {
        '${tProjectsIds[0]}':{'${tVisitsIdsP1[0]}':[]},
        '${tProjectsIds[1]}':{
          '${tVisitsIdsP2[0]}':[], 
          '${tVisitsIdsP2[1]}':formulariosToJson( tFormulariosP2V2 ),
          '${tVisitsIdsP2[2]}':formulariosToJson( tFormulariosP2V3 )
        },
      };
    });

    test('should get the formularios of the visit of the project successfuly', ()async{
      when(storageConnector.getMap(any)).thenAnswer((realInvocation) async => tPreloaded2Projects3VisitsData2FormsData);
      List<FormularioModel> formularios = await preloadedLocalDataSource.getPreloadedFormularios(tProjectsIds[1], tVisitsIdsP2[1]);
      verify(storageConnector.getMap(PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
      expect(formularios, equals(tFormulariosP2V2));

      formularios = await preloadedLocalDataSource.getPreloadedFormularios(tProjectsIds[1], tVisitsIdsP2[2]);
      expect(formularios, equals(tFormulariosP2V3));
    });
  });
}

void _testUpdatePreloadedFormularioGroup(){
  group('updatePreloadedFormulario', (){
    int tPreloadedProjectId;
    int tPreloadedVisitId1;
    List<FormularioModel> tFormularios;
    Map<String, dynamic> tJsonUpdatedFormulario;
    Map<String, dynamic> tPreloaded1Project1VisitAllForms;
    List<Map<String, dynamic>> tPreloadedFormulariosWithUpdatedFirstFormulario;
    Map<String, dynamic> tPreloaded1Project1VisitAllForms1Updated;
    
    setUp((){
      tPreloadedProjectId = 1;
      tPreloadedVisitId1 = 2;
      tFormularios = _getFormulariosFromFixtures();
      tJsonUpdatedFormulario = tFormularios[0].toJson();
      tJsonUpdatedFormulario['nombre'] = "un nuevo nombre";
      tJsonUpdatedFormulario['firmers'] = [];
      tPreloaded1Project1VisitAllForms = {
        '$tPreloadedProjectId': {
          '$tPreloadedVisitId1': formulariosToJson(tFormularios)
        }
      };
      tPreloadedFormulariosWithUpdatedFirstFormulario = formulariosToJson(tFormularios);
      tPreloadedFormulariosWithUpdatedFirstFormulario[0] = tJsonUpdatedFormulario;
      tPreloaded1Project1VisitAllForms1Updated = {
        '$tPreloadedProjectId': {
          '$tPreloadedVisitId1': tPreloadedFormulariosWithUpdatedFirstFormulario
        }
      };
    });

    test('should update a preloaded formulario successfuly', ()async{
      when(storageConnector.getMap(any)).thenAnswer((_) async => jsonDecode( jsonEncode(tPreloaded1Project1VisitAllForms)));
      FormularioModel tFormulario = FormularioModel.fromJson(tJsonUpdatedFormulario);
      await preloadedLocalDataSource.updatePreloadedFormulario(tPreloadedProjectId, tPreloadedVisitId1, tFormulario);
      verify(storageConnector.setMap(tPreloaded1Project1VisitAllForms1Updated, PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
    });
    
  });
}

void _testRemovePreloadedFormularioGroup(){
  group('removePreloadedFormulario', (){
    List<int> tProjectsIds;
    List<int> tVisitsIdsP1;
    List<int> tVisitsIdsP2;
    List<FormularioModel> tFormulariosP2V2;
    List<FormularioModel> tFormulariosP2V3;
    List<FormularioModel> tFormulariosp2V2WithRemovedOne;
    Map<String, dynamic> tPreloaded2Projects3VisitsData3FormsData;
    Map<String, dynamic> tPreloaded2Projects3VisitsData2FormsData;

    setUp((){
      tProjectsIds = [1,2];
      tVisitsIdsP1 = [1];
      tVisitsIdsP2 = [1,2,3];
      tFormulariosP2V2 = _getFormulariosFromFixtures();
      tFormulariosp2V2WithRemovedOne = _getFormulariosFromFixtures()..removeAt(0);
      tFormulariosP2V3 = [tFormulariosP2V2[1]];
      tPreloaded2Projects3VisitsData3FormsData = {
        '${tProjectsIds[0]}':{'${tVisitsIdsP1[0]}':[]},
        '${tProjectsIds[1]}':{
          '${tVisitsIdsP2[0]}':[], 
          '${tVisitsIdsP2[1]}':formulariosToJson( tFormulariosP2V2 ),
          '${tVisitsIdsP2[2]}':formulariosToJson( tFormulariosP2V3 )
        },
      };
      tPreloaded2Projects3VisitsData2FormsData = {
        '${tProjectsIds[0]}':{'${tVisitsIdsP1[0]}':[]},
        '${tProjectsIds[1]}':{
          '${tVisitsIdsP2[0]}':[], 
          '${tVisitsIdsP2[1]}':formulariosToJson( tFormulariosp2V2WithRemovedOne ),
          '${tVisitsIdsP2[2]}':formulariosToJson( tFormulariosP2V3 )
        },
      };
    });

    test('should remove a formulario from its visit from its project successfuly', ()async{
      when(storageConnector.getMap(any)).thenAnswer((realInvocation) async => tPreloaded2Projects3VisitsData3FormsData);
      await preloadedLocalDataSource.removePreloadedFormulario(tFormulariosP2V2[0].id);
      
      verify(storageConnector.getMap(PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
      verify(storageConnector.setMap(tPreloaded2Projects3VisitsData2FormsData, PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
    });
  });
}

void _testDeleteAllGroup(){
  group('deleteAll', (){
    test('should delete all successfuly', ()async{
      await preloadedLocalDataSource.deleteAll();
      verify(storageConnector.remove(PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
    });
  });
}

MuestreoModel _getMuestreoFromFixtures(){
  final String sMuestreo = callFixture('muestreo.json');
  final Map<String, dynamic> jMuestreo = jsonDecode(sMuestreo);
  return MuestreoModel.fromJson(jMuestreo);
}
