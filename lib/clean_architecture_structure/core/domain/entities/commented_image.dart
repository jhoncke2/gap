import 'dart:io';

import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class CommentedImage extends Equatable{
  String commentary;
  int positionInPage;
  String imgnUrl;

  CommentedImage({
    @required this.commentary,
    @required this.imgnUrl,
    this.positionInPage,
  });

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class UnSentCommentedImage extends CommentedImage{

  File image;

  UnSentCommentedImage({
    @required this.image,  
    String commentary = '',
    int positionInPage,
  }):super(
    commentary: commentary,
    imgnUrl: image.path,
    positionInPage: positionInPage
  );

  @override
  List<Object> get props => super.props..add(image.path);
}

// ignore: must_be_immutable
class SentCommentedImage extends CommentedImage{
  static final String baseUrl = 'https://gapfergon.com/';

  SentCommentedImage({
    @required String url,
    String commentary = ''
  }):
  super(
    commentary: commentary,
    imgnUrl: baseUrl + url
  );
}