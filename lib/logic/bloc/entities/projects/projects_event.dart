part of 'projects_bloc.dart';

@immutable
abstract class ProjectsEvent {}

class SetProjects extends ProjectsEvent{
  final List<Project> projects;
  SetProjects({
    @required this.projects,
  });
}
class ChooseProject extends ProjectsEvent{
  final Project chosenOne;
  ChooseProject({
    @required this.chosenOne,
  });
}

class ResetProyects extends ProjectsEvent{}