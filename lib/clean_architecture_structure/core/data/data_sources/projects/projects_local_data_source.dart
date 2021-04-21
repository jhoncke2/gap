import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';

abstract class ProjectsLocalDataSource{
  Future<void> setProjects(List<ProjectModel> projects);
  Future<List<ProjectModel>> getProjects();
  Future<void> setChosenProject(ProjectModel project);
  Future<ProjectModel> getChosenProject();
}

class ProjectsLocalDataSourceImpl implements ProjectsLocalDataSource{
  static const projectsStorageKey = 'projects';
  static const chosenProjectStorageKey = 'chosen_project';
  final StorageConnector storageConnector;

  ProjectsLocalDataSourceImpl({
    @required this.storageConnector
  });

  @override
  Future<void> setProjects(List<ProjectModel> projects)async{
    final List<Map<String, dynamic>> jsonProjects = projectsToJson(projects);
    await storageConnector.setList(jsonProjects, projectsStorageKey);
  }

  @override
  Future<List<ProjectModel>> getProjects()async{
    final List<Map<String, dynamic>> jsonProjects = await storageConnector.getList(projectsStorageKey);
    return projectsFromJson(jsonProjects);
  }

  

  @override
  Future<void> setChosenProject(ProjectModel project)async{
    await storageConnector.setString('${project.id}', chosenProjectStorageKey);
  }

  @override
  Future<ProjectModel> getChosenProject()async{
    final String stringChosenProjectId = await storageConnector.getString(chosenProjectStorageKey);
    final int chosenProjectId = int.parse(stringChosenProjectId);
    final List<Map<String, dynamic>> jsonProjects = await storageConnector.getList(projectsStorageKey);
    final Map<String, dynamic> jsonChosenProject = jsonProjects.singleWhere((p) => p['id'] == chosenProjectId);
    return ProjectModel.fromJson(jsonChosenProject);
  }
}