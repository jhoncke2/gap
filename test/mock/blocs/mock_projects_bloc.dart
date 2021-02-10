import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_storage_manager.dart';

import '../mock_storage_connector.dart';

class MockProjectsBloc extends ProjectsBloc{

  MockProjectsBloc(): super(){
    super.projectsSM = ProjectsStorageManager.forTesting(storageConnector: MockStorageConnector());
  }

  @override
  void add(ProjectsEvent event) {
    print('nuevo event: $event');
    super.mapEventToState(event);
  }
  
}