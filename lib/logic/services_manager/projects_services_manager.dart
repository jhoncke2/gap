import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/services/projects_service.dart';
class ProjectsServicesManager{
  static Future<List<Project>> loadProjects(ProjectsBloc bloc, String accessToken)async{
    final List<Map<String, dynamic>> projectsResponse = await projectsService.getProjects(accessToken);
    final List<Project> projects = projectsFromJson(projectsResponse);
    return projects;
  }

  static Future updateForm(Formulario form, int visitId, String accessToken)async{
    
  }
}