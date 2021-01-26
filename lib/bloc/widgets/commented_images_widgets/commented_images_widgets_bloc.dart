import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gap/models/ui/commented_image.dart';
import 'package:gap/widgets/commented_images/commented_image.dart';
import 'package:meta/meta.dart';

part 'commented_images_widgets_event.dart';
part 'commented_images_widgets_state.dart';

final int _nWidgetsPerPage = 3;

class CommentedImagesWidgetsBloc extends Bloc<CommentedImagesWidgetsEvent, CommentedImagesWidgetsState> {
  final _CommentedImagesGenerator _commentedImagesGenerator = _CommentedImagesGenerator();
  CommentedImagesWidgetsState _currentStateToYield;
  CommentedImagesWidgetsBloc() : super(CommentedImagesWidgetsInitialState());

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
    _evaluateEventOnEnd(event);
  }

  void _evaluateEventOnEnd(CommentedImagesWidgetsEvent event){
    if(event.hasOnEndFunction)
      event.onEnd();
  }

  void _addCommentedImages(AddImages event){
    _commentedImagesGenerator.currentEvent = event;
    _currentStateToYield = _commentedImagesGenerator.generateCommentedImages();
  }

  void _resetAll(){
    _currentStateToYield = CommentedImagesWidgetsInitialState();
  }
}



class _CommentedImagesGenerator{
  AddImages currentEvent;
  int _currentNPages;
  List<CommentedImage> _currentCommentedImages;

  CommentedLoadedImagesWidgetsState generateCommentedImages(){
    _initEventValues();
    final List<List<Widget>> commImagesWidgetsPerPage = _generateCommImagesWidgetsPerPage();
    return CommentedLoadedImagesWidgetsState(
      nPaginasDeWidgets: _currentNPages,
      nWidgetsPerPage: _nWidgetsPerPage,
      commentedImageswidgetsPerPage: commImagesWidgetsPerPage
    );
  }

  void _initEventValues(){
    _currentCommentedImages = _transformToCommentedImages();
    final double unExactlyNPages = _currentCommentedImages.length /_nWidgetsPerPage;
    _currentNPages = unExactlyNPages.ceil();
  }

  List<CommentedImage> _transformToCommentedImages(){
    final List<CommentedImage> commImages = currentEvent.images.map<CommentedImage>(
      (File image) => CommentedImage(image: image, commentary: '')
    ).toList();
    return commImages;
  }

  List<List<Widget>> _generateCommImagesWidgetsPerPage(){
    final List<List<Widget>> commImagesWidgetsPerPage = [];
    for(int pageIndex = 0; pageIndex < _currentNPages; pageIndex++){
      final List<Widget> widgetsOfCurrentPage = _createWidgetsForCurrentPage(pageIndex);
      commImagesWidgetsPerPage.add(widgetsOfCurrentPage);
    }
    return commImagesWidgetsPerPage;
  }

  List<Widget> _createWidgetsForCurrentPage(int pageIndex){
    final List<Widget> widgetsOfCurrentPage = [];
    final int sobrante = _definirSobranteDeUltimaPageIndex(pageIndex);
    for(int j = 0; j < _nWidgetsPerPage - sobrante; j++){
      final CommentedImage commImage = _currentCommentedImages[pageIndex*_nWidgetsPerPage + j];
      final CommentedImageCard commImgCard = CommentedImageCard(commentedImage: commImage);
      widgetsOfCurrentPage.add(commImgCard);
    }
    return widgetsOfCurrentPage;
  }

  int _definirSobranteDeUltimaPageIndex(int pageIndex){
    int sobrante;
    if(pageIndex == _currentNPages-1)
      sobrante =  ((pageIndex + 1)*_nWidgetsPerPage - _currentCommentedImages.length).abs();
    else
      sobrante = 0;
    return sobrante;
  }

}
