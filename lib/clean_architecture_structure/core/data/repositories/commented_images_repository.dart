import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/commented_image.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/commented_images_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/commented_images/commented_images_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/visits/visits_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';

class CommentedImagesRepositoryImpl implements CommentedImagesRepository{
  final NetworkInfo networkInfo;
  final CommentedImagesRemoteDataSource remoteDataSource;
  final UserLocalDataSource userLocalDataSource;
  final ProjectsLocalDataSource projectsLocalDataSource;
  final VisitsLocalDataSource visitsLocalDataSource;

  CommentedImagesRepositoryImpl({
    @required this.networkInfo, 
    @required this.remoteDataSource, 
    @required this.userLocalDataSource, 
    @required this.projectsLocalDataSource, 
    @required this.visitsLocalDataSource
  });

  @override
  Future<Either<Failure, void>> setCommentedImages(List<UnSentCommentedImage> commImgs)async{
    try{
      if(await networkInfo.isConnected()){
        final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
        final VisitModel chosenVisit = await visitsLocalDataSource.getChosenVisit(chosenProject.id);
        final String accessToken = await userLocalDataSource.getAccessToken();
        await remoteDataSource.setCommentedImages(commImgs, chosenVisit.id, accessToken);
      }
      return Right(null);
    }on ServerException catch(exception){
      return Left(ServerFailure(servExcType: exception.type));
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }

  @override
  Future<Either<Failure, List<SentCommentedImage>>> getCommentedImages()async{
    try{
      if(await networkInfo.isConnected()){
        final ProjectModel chosenProject = await projectsLocalDataSource.getChosenProject();
        final VisitModel chosenVisit = await visitsLocalDataSource.getChosenVisit(chosenProject.id);
        final String accessToken = await userLocalDataSource.getAccessToken();
        final List<SentCommentedImage> commentedImages = await remoteDataSource.getCommentedImages(chosenVisit.id, accessToken);
        return Right(commentedImages);
      }else
        return Right([]);
    }on ServerException catch(exception){
      return Left(ServerFailure(servExcType: exception.type));
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }
}