import 'dart:io';
import 'package:flutter/material.dart';

class CommentedImage{
  final File image;
  int positionInPage;
  String commentary;
  
  CommentedImage({
    @required this.image,  
    this.positionInPage, 
    this.commentary = ''
  });
}