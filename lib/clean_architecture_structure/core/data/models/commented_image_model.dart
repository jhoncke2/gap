import 'dart:io';
import 'package:gap/clean_architecture_structure/core/domain/commented_image.dart';

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
  SentCommentedImageModel({
    String url,
    String commentary
  }):super(
    url: url,
    commentary: commentary
  );

  factory SentCommentedImageModel.fromJson(Map<String, dynamic> json)=>SentCommentedImageModel(
    url: json['ruta'],
    commentary: json['descripcion'],
  );
}