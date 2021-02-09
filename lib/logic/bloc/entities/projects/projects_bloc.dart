import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_storage_manager.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:meta/meta.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final ProjectsStorageManager _projectsSM = ProjectsStorageManager();
  ProjectsState _currentYieldedState;
  ProjectsBloc() : super(ProjectsState());

  @override
  Stream<ProjectsState> mapEventToState(
    ProjectsEvent event,
  ) async* {
    if(event is SetProjects){
      _setProjects(event);
    }else if(event is ChooseProject){
      _chooseProject(event);
    }else if(event is ResetProyects){
      _resetAll();
    }
    yield _currentYieldedState;
  }

  void _setProjects(SetProjects event){
    final List<Project> projects = event.projects;
    _currentYieldedState = state.copyWith(
      projectsAreLoaded: true, 
      projects: projects
    );
    _projectsSM.setProjects(projects);
  }
  
  void _chooseProject(ChooseProject event){
    final Project chosenOne = event.chosenOne;
    _currentYieldedState = state.copyWith(chosenProject: chosenOne);
    _projectsSM.setChosenProject(chosenOne);
  }

  void _resetAll(){
    _currentYieldedState = state.reset();
    _projectsSM.removeProjects();
    _projectsSM.removeChosenProject();
  }

}


