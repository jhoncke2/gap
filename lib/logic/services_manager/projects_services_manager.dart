import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/services/projects_service.dart';
class ProjectsServicesManager{
  static Future<List<Project>> loadProjects(ProjectsBloc bloc, String accessToken)async{
    //TODO: Iplementar services
    final List<Project> oldProjects = fakeData.oldProjects;
    bloc.add(SetOldProjects(oldProjects: oldProjects));
    ProjectsStorageManager.setProjects(oldProjects);
    
    final List<Map<String, dynamic>> projectsResponse = await projectsService.getProjects(accessToken);
    final List<Project> projects = projectsFromJson(projectsResponse);
    return projects;
  }
}