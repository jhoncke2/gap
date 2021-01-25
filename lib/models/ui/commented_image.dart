import 'dart:io';
import 'package:flutter/material.dart';

class CommentedImage{
  final File image;
  final String commentary;

  CommentedImage({
    @required this.image,    
    @required this.commentary
  });
}