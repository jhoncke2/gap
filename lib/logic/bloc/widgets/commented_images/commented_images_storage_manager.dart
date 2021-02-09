import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class CommentedImagesStorageManager{
  final String commentedImagesKey = 'commented_images';
  final StorageConnector storageConnector;
  
  CommentedImagesStorageManager():
    this.storageConnector = StorageConnectorSingleton.storageConnector
    ;
  
  CommentedImagesStorageManager.forTesting({
    @required this.storageConnector
  });

    Future<void> setCommentedImages(List<CommentedImage> projects)async{
    final List<Map<String, dynamic>> projectsAsJson = _convertCommentedImagesToJson(projects);
    await storageConnector.setListResource(commentedImagesKey, projectsAsJson);
  }

  List<Map<String, dynamic>> _convertCommentedImagesToJson(List<CommentedImage> commentedImages){
    final List<Map<String, dynamic>> commentedImagesAsJson = [];
    commentedImages.forEach((CommentedImage ci)async{
      final Map<String, dynamic> ciAsJson = ci.toJson();
      commentedImagesAsJson.add(ciAsJson);
    });
    return commentedImagesAsJson;
  }

  Future<List<CommentedImage>> getCommentedImages()async{
    final List<Map<String, dynamic>> commentedImagesAsJson = await storageConnector.getListResource(commentedImagesKey);
    final List<CommentedImage> commentedImages = _convertJsonCommentedImagesToObject(commentedImagesAsJson);
    return commentedImages;
  }

  List<CommentedImage> _convertJsonCommentedImagesToObject(List<Map<String, dynamic>> commentedImagesAsJson){
    
    return commentedImagesAsJson.map<CommentedImage>(
      (Map<String, dynamic> jsonProject) => CommentedImage.fromJson(jsonProject)
    ).toList();
  }

  Future<void> removeCommentedImages()async{
    await storageConnector.removeResource(commentedImagesKey);
  }
}