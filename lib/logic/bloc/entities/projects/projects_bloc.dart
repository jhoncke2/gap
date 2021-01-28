import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gap/logic/models/entities/project.dart';
import 'package:meta/meta.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
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
  }
  void _chooseProject(ChooseProject event){
    final Project chosenOne = event.chosenOne;
    _currentYieldedState = state.copyWith(chosenProject: chosenOne);
  }

  void _resetAll(){
    _currentYieldedState = state.reset();
  }

}


