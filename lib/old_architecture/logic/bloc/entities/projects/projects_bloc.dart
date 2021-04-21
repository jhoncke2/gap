import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gap/old_architecture/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:meta/meta.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  
  @protected
  ProjectsStorageManager projectsSM;
  ProjectsState _currentYieldedState;

  ProjectsBloc() : 
    projectsSM = ProjectsStorageManager(),
    super(ProjectsState())
    ;

  @override
  Stream<ProjectsState> mapEventToState(
    ProjectsEvent event,
  ) async* {
    if(event is SetProjects){
      _setProjects(event);
    }else if(event is ChooseProject){
      _chooseProject(event);
    }else if(event is RemoveChosenProject){
      removeChosenProject();
    }else if(event is ResetProjects){
      resetAll();
    }
    yield _currentYieldedState;
  }

  @protected
  void setOldProjects(SetOldProjects event){
    final List<ProjectOld> oldProjects = event.oldProjects;
    _currentYieldedState = state.copyWith(
      projectsAreLoaded: true, 
      oldProjects: oldProjects
    );
    
  }

  void _setProjects(SetProjects event){
    final List<ProjectOld> projects = event.projects;
    _currentYieldedState = state.copyWith(
      projectsAreLoaded: true,
      projects: projects,
      loadingProjects: false
    );
  }

  void _chooseProject(ChooseProject event){
    final ProjectOld chosenOne = event.chosenOne;
    _currentYieldedState = state.copyWith(chosenProject: chosenOne);
  }

  void removeChosenProject(){

  }

  @protected
  void resetAll(){
    _currentYieldedState = state.reset();
  }
}


