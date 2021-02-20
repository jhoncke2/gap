import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
class ProjectsServicesManager{
  static Future<void> loadProjects(ProjectsBloc bloc)async{
    //TODO: Iplementar services
    final List<Project> projects = fakeData.projects;
    bloc.add(SetProjects(projects: projects));
  }
}