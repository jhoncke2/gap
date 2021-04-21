import 'package:gap/old_architecture/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/old_architecture/logic/storage_managers/projects/projects_storage_manager.dart';

class MockProjectsBloc extends ProjectsBloc{

  MockProjectsBloc(): super(){
    super.projectsSM = ProjectsStorageManager();
  }

  @override
  void add(ProjectsEvent event) {
    print('nuevo event: $event');
    super.mapEventToState(event);
  }
  
}