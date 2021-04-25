import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/commented_image.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

abstract class CommentedImagesRepository{
  Future<Either<Failure, void>> setCommentedImages(List<UnSentCommentedImage> commImgs);
  Future<Either<Failure, List<SentCommentedImage>>> getCommentedImages();
}