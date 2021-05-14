part of 'projects_bloc.dart';

abstract class ProjectsState extends Equatable {
  const ProjectsState();
  
  @override
  List<Object> get props => [];
}

class EmptyProjects extends ProjectsState {}

class LoadingProjects extends ProjectsState {}

class LoadedProjects extends ProjectsState{
  final List<Project> projects;
  LoadedProjects({
    @required this.projects
  });
  @override
  List<Object> get props => [this.projects];
}

class ErrorProjects extends ProjectsState{
  final String message;
  ErrorProjects({
    @required this.message
  });
  @override
  List<Object> get props => [this.message];
}

class LoadingChosenProject extends ProjectsState{}

class LoadedChosenProject extends ProjectsState{
  final Project project;
  LoadedChosenProject({
    @required this.project
  });
}
