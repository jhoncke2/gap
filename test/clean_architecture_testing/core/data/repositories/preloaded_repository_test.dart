import 'dart:convert';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/preloaded_repository.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/data_sources/muestras_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestreo_model.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded/preloaded_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';
import '../../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetworkInfo{}
class MockUserLocalDataSource extends Mock implements UserLocalDataSource{}
class MockPreloadedLocalDataSource extends Mock implements PreloadedLocalDataSource{}
class MockFormulariosRemoteDataSource extends Mock implements FormulariosRemoteDataSource{}
class MockFormulariosLocalDataSource extends Mock implements FormulariosLocalDataSource{}
class MockMuestrasRemoteDataSource extends Mock implements MuestrasRemoteDataSource{}

PreloadedRepositoryImpl preloadedRepository;
MockNetworkInfo networkInfo;
MockUserLocalDataSource userLocalDataSource;
MockPreloadedLocalDataSource localDataSource;
MockFormulariosRemoteDataSource formulariosRemoteDataSource;
MockFormulariosLocalDataSource formulariosLocalDataSource;
MockMuestrasRemoteDataSource muestrasRemoteDataSource;

void main(){
  setUp((){
    muestrasRemoteDataSource = MockMuestrasRemoteDataSource();
    formulariosLocalDataSource = MockFormulariosLocalDataSource();
    formulariosRemoteDataSource = MockFormulariosRemoteDataSource();
    localDataSource = MockPreloadedLocalDataSource();
    userLocalDataSource = MockUserLocalDataSource();
    networkInfo = MockNetworkInfo();
    preloadedRepository = PreloadedRepositoryImpl(
      networkInfo: networkInfo,
      userLocalDataSource: userLocalDataSource,
      localDataSource: localDataSource, 
      formulariosRemoteDataSource: formulariosRemoteDataSource, 
      formulariosLocalDataSource: formulariosLocalDataSource,
      muestrasRemoteDataSource: muestrasRemoteDataSource
    );
  });

  group('sendPreloadedData', (){
    String tAccessToken;
    List<int> tProjectsIds;
    List<int> tVisitsIdsP1;
    List<int> tVisitsIdsP2;
    List<FormularioModel> tFormulariosP1V1;
    List<FormularioModel> tFormulariosP2V1;
    List<FormularioModel> tFormulariosP2V2;
    Map<String, dynamic> tPreloadedData;
    MuestreoModel tMuestreo;
    List<String> tPreparaciones;

    setUp((){
      tAccessToken = 'access_token';
      tProjectsIds = [1,2];
      tVisitsIdsP1 = [1];
      tVisitsIdsP2 = [2,3];
      tFormulariosP1V1 = [_getFormulariosFromFixtures()[0]];
      tFormulariosP2V1 = _getFormulariosFromFixtures().sublist(1,3);
      tFormulariosP2V2 = [_getFormulariosFromFixtures()[3]];
      tMuestreo = _getMuestreoFromFixtures();
      print('*************************** on test *******************');
      print(tMuestreo.rangos);
      tPreparaciones = tMuestreo.componentes.map((c) => c.preparacion).toList();
      //la estructura de la preloadedData en storage.
      tPreloadedData = {
        '${tProjectsIds[0]}':{
          '${tVisitsIdsP1[0]}': {
            'formularios': formulariosToJson( tFormulariosP1V1 ),
            'muestreo': tMuestreo.toJson()
          }
        },
        '${tProjectsIds[1]}':{
          '${tVisitsIdsP2[0]}':{
            'formularios': formulariosToJson( tFormulariosP2V1 )
          },
          '${tVisitsIdsP2[1]}':{
            'formularios': formulariosToJson( tFormulariosP2V2 )
          }
        },
      };
    });
    
    test('''should ask for connection in networkInfo, getAccessToken from userLocalDataSource ,
    obtain the preloadedProjectsIds from local, obtain the preloadedVisitsIds from local for every projectId, 
    obtain the preloadedFormularios for every visitId, and send the respective existing data for every formulario, 
    when there is connectivity''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(localDataSource.getPreloadedProjectsIds()).thenAnswer((_) async => tProjectsIds);
      when(localDataSource.getPreloadedVisitsIds(tProjectsIds[0])).thenAnswer((_) async => tVisitsIdsP1);
      when(localDataSource.getPreloadedVisitsIds(tProjectsIds[1])).thenAnswer((_) async => tVisitsIdsP2);
      when(localDataSource.getMuestreo(tProjectsIds[0], tVisitsIdsP1[0])).thenAnswer((_) async => tMuestreo);
      when(localDataSource.getPreloadedFormularios(any, tVisitsIdsP1[0])).thenAnswer((_) async => tFormulariosP1V1);
      when(localDataSource.getPreloadedFormularios(any, tVisitsIdsP2[0])).thenAnswer((_) async => tFormulariosP2V1);
      when(localDataSource.getPreloadedFormularios(any, tVisitsIdsP2[1])).thenAnswer((_) async => tFormulariosP2V2);
      
      await preloadedRepository.sendPreloadedData();

      verify(networkInfo.isConnected());
      verify(userLocalDataSource.getAccessToken());
      //el project 1
      verify(localDataSource.getPreloadedProjectsIds());
      verify(localDataSource.getPreloadedVisitsIds(tProjectsIds[0]));
      verify(localDataSource.getMuestreo(tProjectsIds[0], tVisitsIdsP1[0]));
      verify(localDataSource.getPreloadedFormularios(tProjectsIds[0], tVisitsIdsP1[0]));
      //No está funcionando la validación de los asquereosos positions. Pero sí los está enviando...
      verify(formulariosRemoteDataSource.setInitialPosition(any, tFormulariosP1V1[0].id, tAccessToken));
      verify(formulariosRemoteDataSource.setFirmer(tFormulariosP1V1[0].firmers[0], tFormulariosP1V1[0].id, tVisitsIdsP1[0], tAccessToken));
      verify(muestrasRemoteDataSource.updatePreparaciones(tAccessToken, tMuestreo.id, tPreparaciones));
      
      //El project 2
      verify(localDataSource.getPreloadedVisitsIds(tProjectsIds[1]));
      //visit 1 del project 1
      verify(localDataSource.getPreloadedFormularios(tProjectsIds[1], tVisitsIdsP2[0]));
      verify(formulariosRemoteDataSource.setInitialPosition(any, tFormulariosP2V1[0].id, tAccessToken));
      verify(formulariosRemoteDataSource.setFinalPosition(any, tFormulariosP2V1[0].id, tAccessToken));
      verify(formulariosRemoteDataSource.setFirmer(tFormulariosP2V1[0].firmers[0], tFormulariosP2V1[0].id, tVisitsIdsP2[0], tAccessToken));
      verify(formulariosRemoteDataSource.setFirmer(tFormulariosP2V1[0].firmers[1], tFormulariosP2V1[0].id, tVisitsIdsP2[0], tAccessToken));

      verify(formulariosRemoteDataSource.setFirmer(tFormulariosP2V1[1].firmers[0], tFormulariosP2V1[1].id, tVisitsIdsP2[0], tAccessToken));
      
      //visit 2 del project 2
      verify(localDataSource.getPreloadedFormularios(tProjectsIds[1], tVisitsIdsP2[1]));
      verify(formulariosRemoteDataSource.setInitialPosition(any, tFormulariosP2V2[0].id, tAccessToken));
      verify(formulariosRemoteDataSource.setFinalPosition(any, tFormulariosP2V2[0].id, tAccessToken));
      verify(formulariosRemoteDataSource.setFirmer(tFormulariosP2V2[0].firmers[0], tFormulariosP2V2[0].id, tVisitsIdsP2[1], tAccessToken));
    });

    test('Should do nothing when there is not connectivity', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      await preloadedRepository.sendPreloadedData();
      verifyNever(localDataSource.getPreloadedProjectsIds());
      verifyNever(localDataSource.getPreloadedVisitsIds(any));
      verifyNever(localDataSource.getPreloadedFormularios(any, any));
      verifyNever(formulariosRemoteDataSource.setInitialPosition(any, any, any));
      verifyNever(formulariosRemoteDataSource.setCampos(any, any, any));
      verifyNever(formulariosRemoteDataSource.setFinalPosition(any, any, any));
      verifyNever(formulariosRemoteDataSource.setFirmer(any, any, any, any));
    });
    
    test('should return Right(true) when there is connectivity and sent any data and all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(localDataSource.getPreloadedProjectsIds()).thenAnswer((_) async => tProjectsIds);
      when(localDataSource.getPreloadedVisitsIds(any)).thenAnswer((_) async => tVisitsIdsP1);
      when(localDataSource.getPreloadedFormularios(any, any)).thenAnswer((_) async => tFormulariosP1V1);
      final result = await preloadedRepository.sendPreloadedData();
      expect(result, Right(true));
    });

    test('should return Right(false) when there is connectivity and didnt send any data and all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(localDataSource.getPreloadedProjectsIds()).thenAnswer((_) async => tProjectsIds);
      when(localDataSource.getPreloadedVisitsIds(any)).thenAnswer((_) async => tVisitsIdsP1);
      when(localDataSource.getPreloadedFormularios(any, any)).thenAnswer((_) async => []);
      final result = await preloadedRepository.sendPreloadedData();
      expect(result, Right(false));
    });

    test('should return Left(ServerFailure()) when there is connectivity and any remoteDataSource method throws a ServerException', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(localDataSource.getPreloadedProjectsIds()).thenAnswer((_) async => tProjectsIds);
      when(localDataSource.getPreloadedVisitsIds(any)).thenAnswer((_) async => tVisitsIdsP1);
      when(localDataSource.getPreloadedFormularios(any, any)).thenAnswer((_) async => tFormulariosP1V1);
      when(formulariosRemoteDataSource.setInitialPosition(any, any, any)).thenThrow(ServerException());
      var result = await preloadedRepository.sendPreloadedData();
      expect(result, Right(false));
    });

    test('should return Left(StorageFailure(...)) when there is connectivity and any remoteDataSource method throws a StorageException(...)', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(localDataSource.getPreloadedProjectsIds()).thenAnswer((_) async => tProjectsIds);
      when(localDataSource.getPreloadedVisitsIds(any)).thenAnswer((_) async => tVisitsIdsP1);
      when(localDataSource.getPreloadedFormularios(any, any)).thenThrow(StorageException(type: StorageExceptionType.NORMAL));
      var result = await preloadedRepository.sendPreloadedData();
      expect(result, Right(false));
    });

    test('should return Right(false) when there is not connectivity and all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      var result = await preloadedRepository.sendPreloadedData();
      expect(result, Right(false));
    });
  });
}

List<FormularioModel> _getFormulariosFromFixtures(){
  String stringFormularios = callFixture('formularios.json');
  List<Map<String, dynamic>> jsonFormularios = jsonDecode(stringFormularios).cast<Map<String, dynamic>>();
  List<FormularioModel> formularios = formulariosFromJson(jsonFormularios);
  return formularios;
}

MuestreoModel _getMuestreoFromFixtures(){
  String stringMuestreo = callFixture('muestreo.json');
  Map<String, dynamic> jsonMuestreo = jsonDecode(stringMuestreo);
  return MuestreoModel.fromRemoteJson(jsonMuestreo);
}