import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';

abstract class ProjectsRemoteDataSource{
  Future<List<ProjectModel>> getProjects(String accessToken);
}