import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/entities.dart';
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
    if(event is InitImagesCommenting){
      _initImagesCommenting();
    }else if(event is AddImages){
      _addCommentedImagesFromFiles(event);
    }else if(event is CommentImage){
      _commentImage(event);
    }else if(event is InitSentCommImgsWatching){
      _initSentCommImgsWatching(event);
    }else if(event is ResetCommentedImages){
      _resetAll();
    }
    yield _currentStateToYield;
    _evaluateEventOnEnd(event);
  }

  void _initImagesCommenting(){
    _currentStateToYield = state.copyWith(isLoading: false, dataType: CmmImgDataType.UNSENT);
  }

  void _evaluateEventOnEnd(CommentedImagesEvent event){
    if(event.hasOnEndFunction)
      event.onEnd();
  }

  void _addCommentedImagesFromFiles(AddImages event){
    _currentStateToYield = _commentedImagesGenerator.addCommentedImagesToCurrentCommentedImages(event.images, state._commentedImagesPerPage);
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

  void _initSentCommImgsWatching(InitSentCommImgsWatching event){
    final List<CommentedImage> sentCommImgs = event.sentCommentedImages;
    _currentStateToYield = _commentedImagesGenerator.generateSentCommentedImagesByPage(sentCommImgs);
  }

  void _resetAll(){
    _currentStateToYield = CommentedImagesState();
  }
 
}



class _CommentedImagesGenerator{
  List<List<CommentedImage>> currentCommImgs;
  List<File> newImages;
  int _currentNPages;
  List<CommentedImage> _newCommentedImages;
  CommentedImagesState _currentState;

  CommentedImagesState addCommentedImagesToCurrentCommentedImages(List<File> newImages, List<List<CommentedImage>> currentCommImgs){
    _initUnsentInitialConfig(newImages, currentCommImgs);
    _defineConfigOfNewState(CmmImgDataType.UNSENT);
    return _currentState;
  }

  void _defineConfigOfNewState(CmmImgDataType dataType){
    this.currentCommImgs = _generateCommImgsPerPage();
    _generateState(dataType);
  }

  void _initUnsentInitialConfig(List<File> newImages, List<List<CommentedImage>> currentCommImgs){
    this.newImages = newImages;
    this.currentCommImgs = currentCommImgs;
    _newCommentedImages = _transformToCommentedImages();
    _defineNPages(_newCommentedImages.length);
  }

  List<CommentedImage> _transformToCommentedImages(){
    final List<CommentedImage> commImages = [];
    currentCommImgs.forEach((List<CommentedImage> commImgsForOnePage) {
      commImages.addAll(commImgsForOnePage);
    });
    final List<CommentedImage> newCommImages = this.newImages.map<CommentedImage>(
      (File image) =>  UnSentCommentedImage(image: image, commentary: '')
    ).toList();
    commImages.addAll(newCommImages);
    return commImages;
  }

  void _defineNPages(int totalListLength){
    final double unExactlyNPages = _newCommentedImages.length /_nCommImgsPerPage;
    _currentNPages = unExactlyNPages.ceil();
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

  void _generateState(CmmImgDataType dataType){
    print(currentCommImgs);
    _currentState =  CommentedImagesState(
      nPaginasDeCommImages: _currentNPages,
      commImgsPerPage: _nCommImgsPerPage,
      commentedImagesPerPage: currentCommImgs,
      isLoading: false,
      dataType: dataType
    );
  }

  CommentedImagesState generateSentCommentedImagesByPage(List<CommentedImage> commentedImages){
    _initSentInitialConfig(commentedImages);
    _defineConfigOfNewState(CmmImgDataType.SENT);
    return _currentState;
  }

  void _initSentInitialConfig(List<CommentedImage> commentedImages){
    this.currentCommImgs = [];
    _newCommentedImages = commentedImages;
    _defineNPages(_newCommentedImages.length);
  }
}