import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';

abstract class ProjectsLocalDataSource{
  Future<void> setProjects(List<ProjectModel> projects);
  Future<List<ProjectModel>> getProjects();
  Future<void> setChosenProject(ProjectModel project);
  Future<ProjectModel> getChosenProject();
  Future<void> deleteAll();
}

class ProjectsLocalDataSourceImpl implements ProjectsLocalDataSource{
  static const PROJECTS_STORAGE_KEY = 'projects';
  static const CHOSEN_PROJECT_STORAGE_KEY = 'chosen_project';
  final StorageConnector storageConnector;

  ProjectsLocalDataSourceImpl({
    @required this.storageConnector
  });

  @override
  Future<void> setProjects(List<ProjectModel> projects)async{
    final List<Map<String, dynamic>> jsonProjects = projectsToJson(projects);
    await storageConnector.setList(jsonProjects, PROJECTS_STORAGE_KEY);
  }

  @override
  Future<List<ProjectModel>> getProjects()async{
    final List<Map<String, dynamic>> jsonProjects = await storageConnector.getList(PROJECTS_STORAGE_KEY);
    return projectsFromJson(jsonProjects);
  }

  @override
  Future<void> setChosenProject(ProjectModel project)async{
    await storageConnector.setString('${project.id}', CHOSEN_PROJECT_STORAGE_KEY);
  }

  @override
  Future<ProjectModel> getChosenProject()async{
    final String stringChosenProjectId = await storageConnector.getString(CHOSEN_PROJECT_STORAGE_KEY);
    final int chosenProjectId = int.parse(stringChosenProjectId);
    final List<Map<String, dynamic>> jsonProjects = await storageConnector.getList(PROJECTS_STORAGE_KEY);
    final Map<String, dynamic> jsonChosenProject = jsonProjects.singleWhere((p) => p['id'] == chosenProjectId);
    return ProjectModel.fromJson(jsonChosenProject);
  }

  @override
  Future<void> deleteAll()async{
    await storageConnector.remove(PROJECTS_STORAGE_KEY);
    await storageConnector.remove(CHOSEN_PROJECT_STORAGE_KEY);
  }
}