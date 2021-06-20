import 'dart:async';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/set_chosen_project.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/get_chosen_project.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/get_projects.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/entities/project.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  static const String GENERAL_PROJECTS_ERROR_MESSAGE = 'Ha ocurrido un error con la obtención de los proyectos';
  static const String GENERAL_CHOSEN_PROJECT_ERROR_MESSAGE = 'Ha ocurrido un error con la obtención de la información del proyecto';
  final GetProjects getProjects;
  final GetChosenProject getChosenProject;
  final SetChosenProject setChosenProject;

  ProjectsBloc({
    @required this.getProjects,
    @required this.getChosenProject,
    @required this.setChosenProject
  }) : super(OnUnloadedProjects());

  @override
  Stream<ProjectsState> mapEventToState(
    ProjectsEvent event,
  ) async* {
    if(event is LoadProjectsEvent)
      yield * _loadProjects(event);
    else if(event is LoadChosenProjectEvent)
      yield * _loadChosenProject();
    else if(event is SetChosenProjectEvent)
      yield * _setChosenProject(event);
  }

  Stream<ProjectsState> _loadProjects(LoadProjectsEvent event)async*{
    final eitherGetProjects = await getProjects(NoParams());
    yield * eitherGetProjects.fold((failure)async*{
      if(failure is ServerFailure)
        yield OnProjectsError(message: failure.message);
      else
        yield OnProjectsError(message: GENERAL_PROJECTS_ERROR_MESSAGE); 
    }, (projects)async*{
      yield OnLoadedProjects(projects: projects);
    });
  }

  Stream<ProjectsState> _loadChosenProject()async*{
    yield OnLoadingChosenProject();
    final eitherGetChosenProject = await getChosenProject(NoParams());
    yield * eitherGetChosenProject.fold((failure)async*{
      String errMessage;
      if(failure is ServerFailure)
        errMessage = failure.message;
      else
        errMessage = GENERAL_CHOSEN_PROJECT_ERROR_MESSAGE;
      yield OnProjectsError(message: errMessage);
    }, (project)async*{
      yield OnLoadedChosenProject(
        project: project
      );
    });
  }

  Stream<ProjectsState> _setChosenProject(SetChosenProjectEvent event)async*{
    yield OnLoadingChosenProject();
    final eitherSetChosenProject = await setChosenProject(ChosenProjectParams(project: event.project));
    yield * eitherSetChosenProject.fold((l)async * {
      yield OnProjectsError(message: GENERAL_CHOSEN_PROJECT_ERROR_MESSAGE);
    }, (_)async * {
      yield OnLoadedChosenProject(project: event.project);
    });
  }
}
