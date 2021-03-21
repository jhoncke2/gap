import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class CommentedImagesStorageManager{
  
  static final String _commentedImagesKey = 'commented_images';
  final StorageConnector storageConnector;
  
  CommentedImagesStorageManager():
    this.storageConnector = StorageConnectorSingleton.storageConnector
    ;

  static Future<void> setCommentedImages(List<UnSentCommentedImage> projects)async{
    final List<Map<String, dynamic>> projectsAsJson = _convertCommentedImagesToJson(projects);
    await StorageConnectorSingleton.storageConnector.setListResource(_commentedImagesKey, projectsAsJson);
  }

  static List<Map<String, dynamic>> _convertCommentedImagesToJson(List<UnSentCommentedImage> commentedImages){
    final List<Map<String, dynamic>> commentedImagesAsJson = [];
    commentedImages.forEach((UnSentCommentedImage ci)async{
      final Map<String, dynamic> ciAsJson = ci.toJson();
      commentedImagesAsJson.add(ciAsJson);
    });
    return commentedImagesAsJson;
  }

  static Future<List<UnSentCommentedImage>> getCommentedImages()async{
    final List<Map<String, dynamic>> commentedImagesAsJson = await StorageConnectorSingleton.storageConnector.getListResource(_commentedImagesKey);
    final List<UnSentCommentedImage> commentedImages = _convertJsonCommentedImagesToObject(commentedImagesAsJson);
    return commentedImages;
  }

  static List<UnSentCommentedImage> _convertJsonCommentedImagesToObject(List<Map<String, dynamic>> commentedImagesAsJson){  
    return commentedImagesAsJson.map<UnSentCommentedImage>(
      (Map<String, dynamic> jsonProject) => UnSentCommentedImage.fromJson(jsonProject)
    ).toList();
  }

  static Future<void> removeCommentedImages()async{
    await StorageConnectorSingleton.storageConnector.removeResource(_commentedImagesKey);
  }
  
}