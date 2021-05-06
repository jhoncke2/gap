import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/use_cases/get_projects.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/project.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  static const String GENERAL_ERROR_MESSAGE = 'Ha ocurrido un error con la obtención de los proyectos';
  final GetProjects getProjects;

  ProjectsBloc({
    @required this.getProjects
  }) : super(LoadingProjects());

  @override
  Stream<ProjectsState> mapEventToState(
    ProjectsEvent event,
  ) async* {
    final eitherGetProjects = await getProjects(NoParams());
    yield * eitherGetProjects.fold((failure)async*{
      if(failure is ServerFailure)
        yield ErrorProjects(message: failure.message);
      else
        yield ErrorProjects(message: GENERAL_ERROR_MESSAGE); 
    }, (projects)async*{
      yield LoadedProjects(projects: projects);
    });
  }
}
