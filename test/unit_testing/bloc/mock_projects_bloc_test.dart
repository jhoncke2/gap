import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import 'package:gap/native_connectors/storage_connector.dart';
import '../../mock/mock_flutter_secure_storage.dart';

final FlutterSecureStorage fss = MockFlutterSecureStorage();

final ProjectsBloc projectsBloc = ProjectsBloc();

main(){
  StorageConnectorSingleton.storageConnector.fss = fss;
  _testBloc1();
}

void _testBloc1(){
  //Nueva forma para testear blocs
  test('test bloc 1', ()async{
    final SetProjects spEvent = SetProjects(projects: fakeData.projects);
    await for(ProjectsState newState in projectsBloc.mapEventToState(spEvent)){
      print('new state: ${newState.projects}');
      expect(newState.projects.length, fakeData.projects.length, reason: 'El length de los objects del state del bloc debe ser el mismo que el de la fakeData');
    }
  });
}
