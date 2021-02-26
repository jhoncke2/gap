part of 'projects_bloc.dart';

@immutable
abstract class ProjectsEvent {}

class SetOldProjects extends ProjectsEvent{
  final List<Project> oldProjects;
  SetOldProjects({
    @required this.oldProjects,
  });
}

class SetProjects extends ProjectsEvent{
  final List<Project> projects;
  SetProjects({
    @required this.projects
  });
}

class ChooseProjectOld extends ProjectsEvent{
  final Project chosenOne;
  ChooseProjectOld({
    @required this.chosenOne,
  });
}

class ChooseProject extends ProjectsEvent{
  final Project chosenOne;
  ChooseProject({
    @required this.chosenOne,
  });
}

class RemoveChosenProject extends ProjectsEvent{}

class ResetProjects extends ProjectsEvent{}