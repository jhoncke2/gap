import 'dart:io';
import 'package:gap/clean_architecture_structure/core/domain/entities/commented_image.dart';

List<SentCommentedImageModel> commentedImagesFromJson(List<Map<String, dynamic>> jsonCommImgs)=>jsonCommImgs.map<SentCommentedImageModel>((json)=>SentCommentedImageModel.fromJson(json)).toList();
List<Map<String, dynamic>> commentedImagesToJson(List<UnSentCommentedImageModel> cmmImgs)=>cmmImgs.map((cmmImg) => cmmImg.toJson()).toList();

// ignore: must_be_immutable
class UnSentCommentedImageModel extends UnSentCommentedImage{
  UnSentCommentedImageModel({
    File image,
    String commentary,
    int positionInPage
  }): super(
    image: image,
    commentary: commentary,
    positionInPage: positionInPage  
  );

  factory UnSentCommentedImageModel.fromJson(Map<String, dynamic> json)=>UnSentCommentedImageModel(
    image: File(json['image_url']),
    commentary: json['commentary'],
    positionInPage: json['position_in_page']
  );

  Map<String, dynamic> toJson() => {
    'image_url':image.path,    
    'commentary':commentary,
    'position_in_page':positionInPage    
  };
}

// ignore: must_be_immutable
class SentCommentedImageModel extends SentCommentedImage{
  static final String baseUrl = 'https://gapfergon.com';
  SentCommentedImageModel({
    String url,
    String commentary
  }):super(
    url: url,
    commentary: commentary
  );

  factory SentCommentedImageModel.fromJson(Map<String, dynamic> json)=>SentCommentedImageModel(
    url: baseUrl + json['ruta'],
    commentary: json['descripcion'],
  );
}