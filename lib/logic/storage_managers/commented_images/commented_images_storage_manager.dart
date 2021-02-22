import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class CommentedImagesStorageManager{
  
  static final String _commentedImagesKey = 'commented_images';
  final StorageConnector storageConnector;
  
  CommentedImagesStorageManager():
    this.storageConnector = StorageConnectorSingleton.storageConnector
    ;

  static Future<void> setCommentedImages(List<CommentedImage> projects)async{
    final List<Map<String, dynamic>> projectsAsJson = _convertCommentedImagesToJson(projects);
    await StorageConnectorSingleton.storageConnector.setListResource(_commentedImagesKey, projectsAsJson);
  }

  static List<Map<String, dynamic>> _convertCommentedImagesToJson(List<CommentedImage> commentedImages){
    final List<Map<String, dynamic>> commentedImagesAsJson = [];
    commentedImages.forEach((CommentedImage ci)async{
      final Map<String, dynamic> ciAsJson = ci.toJson();
      commentedImagesAsJson.add(ciAsJson);
    });
    return commentedImagesAsJson;
  }

  static Future<List<CommentedImage>> getCommentedImages()async{
    final List<Map<String, dynamic>> commentedImagesAsJson = await StorageConnectorSingleton.storageConnector.getListResource(_commentedImagesKey);
    final List<CommentedImage> commentedImages = _convertJsonCommentedImagesToObject(commentedImagesAsJson);
    return commentedImages;
  }

  static List<CommentedImage> _convertJsonCommentedImagesToObject(List<Map<String, dynamic>> commentedImagesAsJson){  
    return commentedImagesAsJson.map<CommentedImage>(
      (Map<String, dynamic> jsonProject) => CommentedImage.fromJson(jsonProject)
    ).toList();
  }

  static Future<void> removeCommentedImages()async{
    await StorageConnectorSingleton.storageConnector.removeResource(_commentedImagesKey);
  }
}