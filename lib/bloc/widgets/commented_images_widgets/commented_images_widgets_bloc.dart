import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gap/models/ui/commented_image.dart';
import 'package:gap/widgets/commented_images/commented_image.dart';
import 'package:meta/meta.dart';

part 'commented_images_widgets_event.dart';
part 'commented_images_widgets_state.dart';

class CommentedImagesWidgetsBloc extends Bloc<CommentedImagesWidgetsEvent, CommentedImagesWidgetsState> {
  final int _widgetsPerPage = 3;
  CommentedImagesWidgetsState _currentStateToYield;
  CommentedImagesWidgetsBloc() : super(CommentedImagesWidgetsInitial());

  @override
  Stream<CommentedImagesWidgetsState> mapEventToState(
    CommentedImagesWidgetsEvent event,
  ) async* {
    if(event is AddImages){
      _addCommentedImages(event);
    }else if(event is ResetAllCommentedImages){
      _resetAll();
    }
    yield _currentStateToYield;
  }

  void _addCommentedImages(AddImages event){
    final List<File> images = event.images;
    final List<CommentedImage> commentedImages = _transformToCommentedImages(images);
    final double unExactlyNPages = commentedImages.length /_widgetsPerPage;
    final int nPages = unExactlyNPages.floor();
    final List<List<Widget>> commImagesWidgetsPerPage = _generateCommImagesWidgetsPerPage(nPages, commentedImages);
    _currentStateToYield = CommentedLoadedImagesWidgets(
      nPaginasDeWidgets: nPages,
      widgetsPerPage: _widgetsPerPage,
      commentedImageswidgetsPerPage: commImagesWidgetsPerPage
    );
  }

  List<CommentedImage> _transformToCommentedImages(List<File> images){
    final List<CommentedImage> commImages = images.map<CommentedImage>(
      (File image) => CommentedImage(image: image, commentary: '')
    );
    return commImages;
  }

  List<List<Widget>> _generateCommImagesWidgetsPerPage(int nPages, List<CommentedImage> commentedImages){
    final List<List<Widget>> commImagesWidgetsPerPage = [];
    for(int pageIndex = 0; pageIndex < nPages; pageIndex++){
      final List<Widget> widgetsOfCurrentPage = _createWidgetsForCurrentPage(commentedImages, pageIndex);
      commImagesWidgetsPerPage.add(widgetsOfCurrentPage);
    }
    return commImagesWidgetsPerPage;
  }

  List<Widget> _createWidgetsForCurrentPage(List<CommentedImage> commentedImages, int pageIndex){
    final List<Widget> widgetsOfCurrentPage = [];
    for(int j = 0; j < _widgetsPerPage; j++){
      final CommentedImage commImage = commentedImages[pageIndex*_widgetsPerPage + j];
      final CommentedImageCard commImgCard = CommentedImageCard(commentedImage: commImage);
      widgetsOfCurrentPage.add(commImgCard);
    }
    return widgetsOfCurrentPage;
  }

  void _resetAll(){
    _currentStateToYield = CommentedImagesWidgetsInitial();
  }
}
