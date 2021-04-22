import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/formularios/formularios_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded_data/preloaded_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';
import 'package:mockito/mockito.dart';
import '../../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetworkInfo{}
class MockFormulariosRemoteDataSource extends Mock implements FormulariosRemoteDataSource{}
class MockFormulariosLocalDataSource extends Mock implements FormulariosLocalDataSource{}
class MockPreloadedLocalDataSource extends Mock implements PreloadedLocalDataSource{}
class MockUserLocalDataSource extends Mock implements UserLocalDataSource{}

FormulariosRepositoryImpl formulariosRepository;
MockNetworkInfo networkInfo;
MockFormulariosRemoteDataSource remoteDataSource;
MockFormulariosLocalDataSource localDataSource;
MockPreloadedLocalDataSource preloadedDataSource;
MockUserLocalDataSource userLocalDataSource;

void main(){

  setUp((){
    preloadedDataSource = MockPreloadedLocalDataSource();
    localDataSource = MockFormulariosLocalDataSource();
    remoteDataSource = MockFormulariosRemoteDataSource();
    networkInfo = MockNetworkInfo();
    userLocalDataSource = MockUserLocalDataSource();
    formulariosRepository = FormulariosRepositoryImpl(
      networkInfo: networkInfo, 
      remoteDataSource: remoteDataSource, 
      localDataSource: localDataSource, 
      preloadedDataSource: preloadedDataSource,
      userLocalDataSource: userLocalDataSource
    );
  });

  group('getFormularios', (){
    String tAccessToken;
    List<Formulario> tFormularios;

    setUp((){
      tAccessToken = 'access_token';
      tFormularios = _getFormulariosFromFixture();
    });

    test('should get the formularios from remoteDataSource with tAccessToken when there is connectivity', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(remoteDataSource.getFormularios(any)).thenAnswer((_) async => tFormularios);
      await formulariosRepository.getFormularios();
      verify(networkInfo.isConnected());
      verify(userLocalDataSource.getAccessToken());
      verify(remoteDataSource.getFormularios(tAccessToken));
    });
  });
}

List<Formulario> _getFormulariosFromFixture(){
  final String stringVisits = callFixture('formularios.json');
  final List<Map<String, dynamic>> jsonVisits = jsonDecode(stringVisits).cast<Map<String, dynamic>>();
  final List<Formulario> visits = formulariosFromJson(jsonVisits);
  return visits;
} 