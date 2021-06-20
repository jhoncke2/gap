part of 'projects_bloc.dart';

abstract class ProjectsState extends Equatable {
  const ProjectsState();
  
  @override
  List<Object> get props => [];
}

class OnUnloadedProjects extends ProjectsState {}

class OnLoadingProjects extends ProjectsState {}

class OnLoadedProjects extends ProjectsState{
  final List<Project> projects;
  OnLoadedProjects({
    @required this.projects
  });
  @override
  List<Object> get props => [this.projects];
}

class OnProjectsError extends ProjectsState{
  final String message;
  OnProjectsError({
    @required this.message
  });
  @override
  List<Object> get props => [this.message];
}

class OnLoadingChosenProject extends ProjectsState{}

class OnLoadedChosenProject extends ProjectsState{
  final Project project;
  OnLoadedChosenProject({
    @required this.project
  });
}
