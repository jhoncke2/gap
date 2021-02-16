import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/storage_managers/commented_images/commented_images_storage_manager.dart';
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
    }else if(event is ResetCommentedImages){
      _resetAll();
    }else if(event is SetCommentedImages){
      _setCommentedImages(event);
    }
    yield _currentStateToYield;
    _evaluateEventOnEnd(event);
  }

  void _evaluateEventOnEnd(CommentedImagesEvent event){
    if(event.hasOnEndFunction)
      event.onEnd();
  }

  void _addCommentedImages(AddImages event){
    _commentedImagesGenerator.commentedImagesPerPage = state._commentedImagesPerPage;
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

  void _setCommentedImages(SetCommentedImages event){
    final List<CommentedImage> commentedImages = event.commentedImages;
    _currentStateToYield = state.copyWith();
  }
 
}



class _CommentedImagesGenerator{
  List<List<CommentedImage>> commentedImagesPerPage;
  AddImages currentEvent;
  int _currentNPages;
  List<CommentedImage> _newCommentedImages;
  CommentedImagesState _currentState;

  CommentedImagesState generateCommentedImages(){
    _initEventValues();
    commentedImagesPerPage = _generateCommImgsPerPage();
    _generateState();
    return _currentState;
  }

  //TODO: Probar que funcione
  CommentedImagesState generateCommentedImagesFromExisting(List<CommentedImage> commImgs){
    commentedImagesPerPage = [];
    _newCommentedImages = commImgs;
    commentedImagesPerPage = _generateCommImgsPerPage();
    _defineNPages(commImgs.length);
    _generateState();
    return _currentState;
  }

  void _generateState(){
    _currentState =  CommentedImagesState(
      nPaginasDeCommImages: _currentNPages,
      commImgsPerPage: _nCommImgsPerPage,
      commentedImagesPerPage: commentedImagesPerPage
    );
  }

  void _initEventValues(){
    _newCommentedImages = _transformToCommentedImages();
    _defineNPages(_newCommentedImages.length);
  }

  void _defineNPages(int totalListLength){
    final double unExactlyNPages = _newCommentedImages.length /_nCommImgsPerPage;
    _currentNPages = unExactlyNPages.ceil();
  }

  List<CommentedImage> _transformToCommentedImages(){
    final List<CommentedImage> commImages = [];
    commentedImagesPerPage.forEach((List<CommentedImage> commImgsForOnePage) {
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
      sobrante = ((pageIndex + 1)*_nCommImgsPerPage - _newCommentedImages.length).abs();
    else
      sobrante = 0;
    return sobrante;
  }
}