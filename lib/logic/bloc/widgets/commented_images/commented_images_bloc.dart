import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gap/logic/models/entities/commented_image.dart';
import 'package:meta/meta.dart';

part 'commented_images_event.dart';
part 'commented_images_state.dart';

final int _nCommImgsPerPage = 3;

class CommentedImagesBloc extends Bloc<CommentedImagesEvent, CommentedImagesState> {
  final _CommentedImagesGenerator _commentedImagesGenerator = _CommentedImagesGenerator();
  CommentedImagesState _currentStateToYield;
  CommentedImagesBloc() : super(CommentedImagesState());

  @override
  Stream<CommentedImagesState> mapEventToState(
    CommentedImagesEvent event,
  ) async* {
    if(event is AddImages){
      _addCommentedImages(event);
    }else if(event is CommentImage){
      _commentImage(event);
    }else if(event is ResetAllCommentedImages){
      _resetAll();
    }
    yield _currentStateToYield;
    _evaluateEventOnEnd(event);
  }

  void _evaluateEventOnEnd(CommentedImagesEvent event){
    if(event.hasOnEndFunction)
      event.onEnd();
  }

  void _addCommentedImages(AddImages event){
    _commentedImagesGenerator.currentCommentedImagesPerPage = state._commentedImagesPerPage;
    _commentedImagesGenerator.currentEvent = event;
    _currentStateToYield = _commentedImagesGenerator.generateCommentedImages();
  }

  void _commentImage(CommentImage event){
    final int page = event.page;
    final int positionInPage = event.positionInPage;
    final String newCommentary = event.commentary;
    final List<List<CommentedImage>> commentedImagesPages = state._commentedImagesPerPage;
    final CommentedImage commImageWithNewCommentary = commentedImagesPages[page][positionInPage];
    commImageWithNewCommentary.commentary = newCommentary;
    _currentStateToYield = state.copyWith();
  }

  void _resetAll(){
    _currentStateToYield = CommentedImagesState();
  }
}



class _CommentedImagesGenerator{
  List<List<CommentedImage>> currentCommentedImagesPerPage;
  AddImages currentEvent;
  int _currentNPages;
  List<CommentedImage> _newCommentedImages;

  CommentedImagesState generateCommentedImages(){
    _initEventValues();
    final List<List<CommentedImage>> newCommImagesWidgetsPerPage = _generateCommImgsPerPage();
    return CommentedImagesState(
      nPaginasDeCommImages: _currentNPages,
      commImgsPerPage: _nCommImgsPerPage,
      commentedImagesPerPage: newCommImagesWidgetsPerPage
    );
  }

  void _initEventValues(){
    _newCommentedImages = _transformToCommentedImages();
    final double unExactlyNPages = _newCommentedImages.length /_nCommImgsPerPage;
    _currentNPages = unExactlyNPages.ceil();
  }

  List<CommentedImage> _transformToCommentedImages(){
    final List<CommentedImage> commImages = [];
    currentCommentedImagesPerPage.forEach((List<CommentedImage> commImgsForOnePage) {
      commImages.addAll(commImgsForOnePage);
    });
    final List<CommentedImage> newCommImages = currentEvent.images.map<CommentedImage>(
      (File image) => CommentedImage(image: image, commentary: '')
    ).toList();
    commImages.addAll(newCommImages);
    return commImages;
  }

  List<List<CommentedImage>> _generateCommImgsPerPage(){
    final List<List<CommentedImage>> commImagesWidgetsPerPage = [];
    for(int pageIndex = 0; pageIndex < _currentNPages; pageIndex++){
      final List<CommentedImage> commImgsOfCurrentPage = _createCommImgsForCurrentPage(pageIndex);
      commImagesWidgetsPerPage.add(commImgsOfCurrentPage);
    }
    return commImagesWidgetsPerPage;
  }

  List<CommentedImage> _createCommImgsForCurrentPage(int pageIndex){
    final List<CommentedImage> commImgsOfCurrentPage = [];
    final int sobrante = _definirSobranteDeUltimaPageIndex(pageIndex);
    for(int j = 0; j < _nCommImgsPerPage - sobrante; j++){
      final CommentedImage commImage = _newCommentedImages[pageIndex*_nCommImgsPerPage + j];
      commImage.positionInPage = j;
      commImgsOfCurrentPage.add(commImage);
    }
    return commImgsOfCurrentPage;
  }

  int _definirSobranteDeUltimaPageIndex(int pageIndex){
    int sobrante;
    if(pageIndex == _currentNPages-1)
      sobrante =  ((pageIndex + 1)*_nCommImgsPerPage - _newCommentedImages.length).abs();
    else
      sobrante = 0;
    return sobrante;
  }
}
