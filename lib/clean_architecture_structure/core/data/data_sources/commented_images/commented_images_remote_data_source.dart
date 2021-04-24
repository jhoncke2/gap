import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/models/commented_image_model.dart';

abstract class CommentedImagesRemoteDataSource{
  Future<void> setCommentedImages(List<UnSentCommentedImageModel> commImgs, int visitId, String accessToken);
  Future<SentCommentedImageModel> getCommentedImages(int visitId, String accessToken);
}

class CommentedImagesRemoteDataSourceImpl{
  final StorageConnector storageConnector;

  CommentedImagesRemoteDataSourceImpl({
    @required this.storageConnector
  });
}