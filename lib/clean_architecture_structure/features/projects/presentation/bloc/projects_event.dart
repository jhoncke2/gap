part of 'projects_bloc.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object> get props => [];
}

class LoadProjectsEvent extends ProjectsEvent{}

class SetChosenProjectEvent extends ProjectsEvent{
  final Project project;
  SetChosenProjectEvent({
    @required this.project
  });
}

class LoadChosenProjectEvent extends ProjectsEvent{}