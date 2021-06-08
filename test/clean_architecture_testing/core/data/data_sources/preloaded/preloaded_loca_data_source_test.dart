import 'dart:convert';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestra_model.dart';
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

  group('getMuestreo', (){
    int tProjectId;
    int tVisitId;
    MuestreoModel tMuestreo;
    Map<String, dynamic> tPreloadedData;
    
    setUp((){
      tProjectId = 1;
      tVisitId = 11;
      tMuestreo = _getMuestreoFromFixtures();
      tPreloadedData = {
        '$tProjectId':{
          '$tVisitId':{
            'muestreo': tMuestreo.toJson()
          },
          '12':{
            'formularios': formulariosToJson( _getFormulariosFromFixtures() )
          }
        },
        '2':{
          '21': {
            'formularios': formulariosToJson( _getFormulariosFromFixtures() )
          }
        }
      };
      when(storageConnector.getMap(any)).thenAnswer((_) async => tPreloadedData);
    });

    test('should call the specified method', ()async{
      await preloadedLocalDataSource.getMuestreo(tProjectId, tVisitId);
      verify(storageConnector.getMap(PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
    });

    test('should return the expected muestreo', ()async{
      final muestreo = await preloadedLocalDataSource.getMuestreo(tProjectId, tVisitId);
      expect(muestreo, tMuestreo);
    });
  });

  group('updateMuestreo', (){
    int tProjectId;
    int tVisitId;
    MuestreoModel tMuestreo;
    MuestreoModel tUpdatedMuestreo;
    Map<String, dynamic> tPreloadedData;
    Map<String, dynamic> tPreloadedDataWithUpdatedMuestreo;
    setUp((){
      tProjectId = 1;
      tVisitId = 11;
      tMuestreo = _getMuestreoFromFixtures();
      tPreloadedData = {
        '$tProjectId': {
          '$tVisitId':{
            'formularios': formulariosToJson( _getFormulariosFromFixtures() ),
            'muestreo': tMuestreo
          }
        }
      };
      tUpdatedMuestreo = _getMuestreoFromFixtures();
      tUpdatedMuestreo.muestrasTomadas.add(
        MuestraModel(
          id: 101, 
          rango: tUpdatedMuestreo.rangos[0].nombre, 
          pesos: tUpdatedMuestreo.componentes.map((c) => 1.0).toList()
        )
      );
      tPreloadedDataWithUpdatedMuestreo = {
        '$tProjectId': {
          '$tVisitId':{
            'formularios': formulariosToJson( _getFormulariosFromFixtures() ),
            'muestreo': tUpdatedMuestreo
          }
        }
      };
    });

    test('should call the specified methods', ()async{
      when(storageConnector.getMap(any)).thenAnswer((_) async => tPreloadedData);
      await preloadedLocalDataSource.updateMuestreo(tProjectId, tVisitId, tUpdatedMuestreo);
      verify(storageConnector.getMap(PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
      verify(storageConnector.setMap(tPreloadedDataWithUpdatedMuestreo, PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
    });
  });

  group('removeMuestreo', (){
    int tProjectId;
    int tVisitId;
    MuestreoModel tMuestreo;
    Map<String, dynamic> tPreloadedData;
    Map<String, dynamic> tPreloadedDataWithoutMuestreo;
    setUp((){
      tProjectId = 1;
      tVisitId = 11;
      tMuestreo = _getMuestreoFromFixtures();
      tPreloadedData = {
        '$tProjectId':{
          '$tVisitId':{
            'muestreo': tMuestreo.toJson()
          },
          '12':{
            'formularios': formulariosToJson( _getFormulariosFromFixtures() )
          }
        }
      };
      tPreloadedDataWithoutMuestreo = {
        '$tProjectId':{
          '12':{
            'formularios': formulariosToJson( _getFormulariosFromFixtures() ),
            'muestreo': null
          }
        }
      };
      when(storageConnector.getMap(any)).thenAnswer((_) async => tPreloadedData);
    });

    test('should call the specified methods', ()async{
      await preloadedLocalDataSource.removeMuestreo(tProjectId, tVisitId, tMuestreo.id);
      verify(storageConnector.getMap(PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
      verify(storageConnector.setMap(tPreloadedDataWithoutMuestreo, PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
    });
  });

  
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
    Map<String, dynamic> tPreloadedData;

    setUp((){
      tProjectsIds = [1,2,3,4];
      tCleanedProjectsIds = [tProjectsIds[0],tProjectsIds[1]];
      tPreloadedData = {
        '${tProjectsIds[0]}':{'1':{
          'formularios': formulariosToJson( _getFormulariosFromFixtures() )
        }},
        '${tProjectsIds[1]}':{'2':{
          'muestreo': _getMuestreoFromFixtures().toJson()
        }, '3':{}},
        '${tProjectsIds[2]}':{},
        '${tProjectsIds[3]}':{}
      };
    });

    test('should call the specified methods', ()async{
      when(storageConnector.getMap(any)).thenAnswer((_) async => tPreloadedData);
      await preloadedLocalDataSource.getPreloadedProjectsIds();
      verify(storageConnector.getMap(PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
    });

    test('should return the specified ids', ()async{
      when(storageConnector.getMap(any)).thenAnswer((_) async => tPreloadedData);
      final ids = await preloadedLocalDataSource.getPreloadedProjectsIds();
      expect(ids, tCleanedProjectsIds);
    });
  });
}

void _testGetPreloadedVisitsIdsGroup(){

  group('getPreloadedVisitsIds', (){
    List<int> tProjectsIds;
    List<int> tCleanedIds;
    Map<String, dynamic> tPreloadedData;
    setUp((){
      tProjectsIds = [1,2,3,4];
      tCleanedIds = [1, 2];
      tPreloadedData = {
        '${tProjectsIds[0]}':{
          '1':{
            'formularios': formulariosToJson( _getFormulariosFromFixtures() )
          },
          '2':{
            'muestreo': _getMuestreoFromFixtures().toJson()
          },
          '3':{}
        },
        '${tProjectsIds[1]}':{'3':{
          'muestreo': _getMuestreoFromFixtures().toJson()
        }, '4':{}},
        '${tProjectsIds[2]}':{},
      };
    });

    test('should call the specified method', ()async{
      when(storageConnector.getMap(any)).thenAnswer((_) async => tPreloadedData);
      await preloadedLocalDataSource.getPreloadedVisitsIds(tProjectsIds[0]);
      verify(storageConnector.getMap(PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
    });

    test('should return the specified ids', ()async{
      when(storageConnector.getMap(any)).thenAnswer((_) async => tPreloadedData);
      final ids = await preloadedLocalDataSource.getPreloadedVisitsIds(tProjectsIds[0]);
      expect(ids, tCleanedIds);
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
    Map<String, dynamic> tPreloadedData;

    setUp((){
      tProjectsIds = [1,2];
      tVisitsIdsP1 = [1];
      tVisitsIdsP2 = [1,2,3];
      tFormulariosP2V2 = _getFormulariosFromFixtures();
      tFormulariosP2V3 = [tFormulariosP2V2[0]];
      tPreloadedData = {
        '${tProjectsIds[0]}':{
          '${tVisitsIdsP1[0]}':{}
        },
        '${tProjectsIds[1]}':{
          '${tVisitsIdsP2[0]}':{}, 
          '${tVisitsIdsP2[1]}':{
            'formularios': formulariosToJson( tFormulariosP2V2 ),
            'muestreo': _getMuestreoFromFixtures().toJson()
          },
          '${tVisitsIdsP2[2]}':{
            'formularios': formulariosToJson( tFormulariosP2V3 )
          }
        },
      };
    });

    test('should call the specified method', ()async{
      when(storageConnector.getMap(any)).thenAnswer((_) async => tPreloadedData);
      await preloadedLocalDataSource.getPreloadedFormularios(tProjectsIds[1], tVisitsIdsP2[1]);
      verify(storageConnector.getMap(PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
    });

    test('should return the specified formularios', ()async{
      when(storageConnector.getMap(any)).thenAnswer((_) async => tPreloadedData);
      final formularios = await preloadedLocalDataSource.getPreloadedFormularios(tProjectsIds[1], tVisitsIdsP2[1]);
      expect(formularios, tFormulariosP2V2);
    });
    
  });


}

void _testUpdatePreloadedFormularioGroup(){

  group('updatePreloadedFormulario', (){
    int tPreloadedProjectId;
    int tPreloadedVisitId1;
    List<FormularioModel> tFormularios;
    Map<String, dynamic> tJsonUpdatedFormulario;
    Map<String, dynamic> tPreloadedData;
    List<Map<String, dynamic>> tPreloadedFormulariosWithUpdatedFirstFormulario;
    Map<String, dynamic> tPreloaded1Project1VisitAllForms1Updated;
    
    setUp((){
      tPreloadedProjectId = 1;
      tPreloadedVisitId1 = 2;
      tFormularios = _getFormulariosFromFixtures();
      tJsonUpdatedFormulario = tFormularios[0].toJson();
      tJsonUpdatedFormulario['nombre'] = "un nuevo nombre";
      tJsonUpdatedFormulario['firmers'] = [];
      tPreloadedData = {
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
      when(storageConnector.getMap(any)).thenAnswer((_) async => tPreloadedData);
      FormularioModel tFormulario = FormularioModel.fromJson(tJsonUpdatedFormulario);
      await preloadedLocalDataSource.updatePreloadedFormularioOld(tPreloadedProjectId, tPreloadedVisitId1, tFormulario);
      verify(storageConnector.setMap(tPreloaded1Project1VisitAllForms1Updated, PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
    });
    
  });

}

void _testRemovePreloadedFormularioGroup(){

  group('removePreloadedFormulario', (){
    int tProjectsId;
    int tVisitId;
    List<FormularioModel> tFormulariosP2V2;
    List<FormularioModel> tFormulariosp2V2WithRemovedOne;
    Map<String, dynamic> tPreloadedData;
    Map<String, dynamic> tPreloadedDataWithRemovedFormulario;

    setUp((){
      tProjectsId = 1;
      tVisitId = 2;
      tFormulariosP2V2 = _getFormulariosFromFixtures();
      tFormulariosp2V2WithRemovedOne = _getFormulariosFromFixtures()..removeAt(0);
      tPreloadedData = {
        '$tProjectsId':{
          '$tVisitId':{
            'formularios': formulariosToJson( tFormulariosP2V2 ),
            'muestreo': _getMuestreoFromFixtures().toJson()
          }
        },
      };
      tPreloadedDataWithRemovedFormulario = {
        '$tProjectsId':{
          '$tVisitId':{
            'formularios': formulariosToJson( tFormulariosp2V2WithRemovedOne ),
            'muestreo': _getMuestreoFromFixtures().toJson()
          }
        },
      };
    });

    test('should call the specified method', ()async{
      when(storageConnector.getMap(any)).thenAnswer((_) async => tPreloadedData);
      await preloadedLocalDataSource.removePreloadedFormulario(tProjectsId, tVisitId, tFormulariosP2V2[0].id);
      verify(storageConnector.getMap(PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
      verify(storageConnector.setMap(tPreloadedDataWithRemovedFormulario, PreloadedLocalDataSourceImpl.PRELOADED_DATA_STORAGE_KEY));
    });
  });

  group('removePreloadedFormularioOld', (){
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
      await preloadedLocalDataSource.removePreloadedFormularioOld(tFormulariosP2V2[0].id);
      
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
  return MuestreoModel.fromRemoteJson(jMuestreo);
}
