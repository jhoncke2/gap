part of 'projects_bloc.dart';

@immutable
class ProjectsState {
  final bool projectsAreLoaded;
  final List<Project> projects;
  final Project chosenProject;

  ProjectsState({
    this.projectsAreLoaded = false, 
    this.projects, 
    this.chosenProject
  });

  ProjectsState copyWith({
    bool projectsAreLoaded, 
    List<Project> projects, 
    Project chosenProject
  }) => ProjectsState(
    projectsAreLoaded: projectsAreLoaded??this.projectsAreLoaded,
    projects: projects??this.projects,
    chosenProject: chosenProject??this.chosenProject    
  );

  ProjectsState reset() => ProjectsState();
}
