import 'package:gap/clean_architecture_structure/core/domain/entities/commented_image.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/commented_images_repository.dart';
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
  Future<Either<Failure, List<SentCommentedImage>>> getCommentedImages() {
    // TODO: implement getCommentedImages
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> setCommentedImages(List<UnSentCommentedImage> commImgs) {
    // TODO: implement setCommentedImages
    throw UnimplementedError();
  }
}