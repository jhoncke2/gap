import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded/preloaded_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/features/projects/domain/entities/project.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/projects_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';

typedef Future<dynamic> _SetOrGetListOrChosen();

class ProjectsRepositoryImpl implements ProjectsRepository{

  final NetworkInfo networkInfo;
  final ProjectsLocalDataSource localDataSource;
  final ProjectsRemoteDataSource remoteDataSource;
  final PreloadedLocalDataSource preloadedLocalDataSource;
  final UserLocalDataSource userLocalDataSource;

  ProjectsRepositoryImpl({
    @required this.networkInfo, 
    @required this.localDataSource,
    @required this.remoteDataSource,
    @required this.preloadedLocalDataSource,
    @required this.userLocalDataSource
  });

  @override
  Future<Either<Failure, List<Project>>> getProjects()async{
    if(await networkInfo.isConnected()){  
      try{
        final String accessToken = await userLocalDataSource.getAccessToken();
        final List<Project> projects = await remoteDataSource.getProjects(accessToken);
        await localDataSource.setProjects(projects);
        return Right(projects);
      }on ServerException{
        return Left(ServerFailure());
      }
    }else{
      try{
        final List<int> preloadedProjectsIds = await preloadedLocalDataSource.getPreloadedProjectsIdsOld();
        List<ProjectModel> projects = await localDataSource.getProjects();
        List<Project> finalProjects = projects.where((p) => preloadedProjectsIds.contains(p.id)).toList();
        return Right(finalProjects);
      }on StorageException catch(exception){
        return Left(StorageFailure(excType: exception.type));
      }
    }
  }

  Future<Either<Failure, List<Project>>> executeGetProjectsMethod(
    Future<List<ProjectModel>> Function() method
  )async{
    try{
      final List<ProjectModel> projects = await method();
      return Right(projects);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }

  @override
  Future<Either<Failure, void>> setChosenProject(Project project)async{
    try{
      await localDataSource.setChosenProject(project);
      return Right(null);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }

  @override
  Future<Either<Failure, Project>> getChosenProject()async{
    try{
      final ProjectModel project = await localDataSource.getChosenProject();
      return Right(project);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }

  Future<Either<Failure, dynamic>> executeGeneralFunction(
    _SetOrGetListOrChosen setOrGetListOrChosen
  )async{
    try{
      final result = await setOrGetListOrChosen();
      return Right(result);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }
}