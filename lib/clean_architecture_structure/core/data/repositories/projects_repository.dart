import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/project.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/projects_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';

class ProjectsRepositoryImpl implements ProjectsRepository{

  final NetworkInfo networkInfo;
  final ProjectsLocalDataSource localDataSource;
  final ProjectsRemoteDataSource remoteDataSource;

  ProjectsRepositoryImpl({
    @required this.networkInfo, 
    @required this.localDataSource, 
    @required this.remoteDataSource
  });

  @override
  Future<Either<Failure, List<Project>>> getProjects() {
    // TODO: implement getProjects
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> setChosenProject(Project project) {
    // TODO: implement setChosenProject
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Project>> getChosenProject() {
    // TODO: implement getChosenProject
    throw UnimplementedError();
  }
}