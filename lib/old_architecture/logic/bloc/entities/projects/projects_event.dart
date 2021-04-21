part of 'projects_bloc.dart';

@immutable
abstract class ProjectsEvent {}

class SetOldProjects extends ProjectsEvent{
  final List<ProjectOld> oldProjects;
  SetOldProjects({
    @required this.oldProjects,
  });
}

class SetProjects extends ProjectsEvent{
  final List<ProjectOld> projects;
  SetProjects({
    @required this.projects
  });
}

class ChooseProject extends ProjectsEvent{
  final ProjectOld chosenOne;
  ChooseProject({
    @required this.chosenOne,
  });
}

class RemoveChosenProject extends ProjectsEvent{}

class ResetProjects extends ProjectsEvent{}