import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/data/models/entities/entities.dart';
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
      setProjects(event);
    }else if(event is ChooseProject){
      chooseProject(event);
    }else if(event is RemoveChosenProject){
      removeChosenProject();
    }else if(event is ResetProjects){
      resetAll();
    }
    yield _currentYieldedState;
  }

  @protected
  void setProjects(SetProjects event){
    final List<Project> projects = event.projects;
    _currentYieldedState = state.copyWith(
      projectsAreLoaded: true, 
      projects: projects
    );
    
  }

  @protected
  void chooseProject(ChooseProject event){
    final Project chosenOne = event.chosenOne;
    _currentYieldedState = state.copyWith(chosenProject: chosenOne);
  }

  void removeChosenProject(){

  }

  @protected
  void resetAll(){
    _currentYieldedState = state.reset();
  }
}


