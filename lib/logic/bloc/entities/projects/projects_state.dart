part of 'projects_bloc.dart';

@immutable
class ProjectsState {
  final bool projectsAreLoaded;
  final List<Project> oldProjects;
  final Project chosenProjectOld;
  final List<Project> projects;
  final Project chosenProject;

  ProjectsState({
    this.projectsAreLoaded = false, 
    this.oldProjects, 
    this.projects,
    this.chosenProject,
    this.chosenProjectOld
  });

  ProjectsState copyWith({
    bool projectsAreLoaded, 
    List<Project> oldProjects, 
    List<Project> projects,
    Project chosenProject,
    Project chosenProjectOld
  }) => ProjectsState(
    projectsAreLoaded: projectsAreLoaded??this.projectsAreLoaded,
    oldProjects: oldProjects??this.oldProjects,
    projects: projects??this.projects,
    chosenProject: chosenProject??this.chosenProject,
    chosenProjectOld: chosenProjectOld??this.chosenProjectOld    
  );

  ProjectsState reset() => ProjectsState();
}
