import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/native_connectors/storage_connector.dart';

class CommentedImagesStorageManager{
  
  static final String _commentedImagesKey = 'commented_images';
  final StorageConnectorOld storageConnector;
  
  CommentedImagesStorageManager():
    this.storageConnector = StorageConnectorOldSingleton.storageConnector
    ;

  static Future<void> setCommentedImages(List<UnSentCommentedImageOld> projects)async{
    final List<Map<String, dynamic>> projectsAsJson = _convertCommentedImagesToJson(projects);
    await StorageConnectorOldSingleton.storageConnector.setListResource(_commentedImagesKey, projectsAsJson);
  }

  static List<Map<String, dynamic>> _convertCommentedImagesToJson(List<UnSentCommentedImageOld> commentedImages){
    final List<Map<String, dynamic>> commentedImagesAsJson = [];
    commentedImages.forEach((UnSentCommentedImageOld ci)async{
      final Map<String, dynamic> ciAsJson = ci.toJson();
      commentedImagesAsJson.add(ciAsJson);
    });
    return commentedImagesAsJson;
  }

  static Future<List<UnSentCommentedImageOld>> getCommentedImages()async{
    final List<Map<String, dynamic>> commentedImagesAsJson = await StorageConnectorOldSingleton.storageConnector.getListResource(_commentedImagesKey);
    final List<UnSentCommentedImageOld> commentedImages = _convertJsonCommentedImagesToObject(commentedImagesAsJson);
    return commentedImages;
  }

  static List<UnSentCommentedImageOld> _convertJsonCommentedImagesToObject(List<Map<String, dynamic>> commentedImagesAsJson){  
    return commentedImagesAsJson.map<UnSentCommentedImageOld>(
      (Map<String, dynamic> jsonProject) => UnSentCommentedImageOld.fromJson(jsonProject)
    ).toList();
  }

  static Future<void> removeCommentedImages()async{
    await StorageConnectorOldSingleton.storageConnector.removeResource(_commentedImagesKey);
  }
  
}