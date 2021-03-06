import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
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
    }else if(event is ChangeCommentedImagesLoading){
      _changeLoading(event.isLoading);
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
    final List<List<CommentedImageOld>> commentedImagesPages = state._commentedImagesPerPage;
    final CommentedImageOld commImageWithNewCommentary = commentedImagesPages[page][positionInPage];
    commImageWithNewCommentary.commentary = newCommentary;
    _currentStateToYield = state.copyWith();
  }

  void _changeLoading(bool isLoading){
    _currentStateToYield = state.copyWith(isLoading: isLoading);
  }

  void _initSentCommImgsWatching(InitSentCommImgsWatching event){
    final List<CommentedImageOld> sentCommImgs = event.sentCommentedImages;
    _currentStateToYield = _commentedImagesGenerator.generateSentCommentedImagesByPage(sentCommImgs);
  }

  void _resetAll(){
    _currentStateToYield = CommentedImagesState();
  }
 
}



class _CommentedImagesGenerator{
  List<List<CommentedImageOld>> currentCommImgs;
  List<File> newImages;
  int _currentNPages;
  List<CommentedImageOld> _newCommentedImages;
  CommentedImagesState _currentState;

  CommentedImagesState addCommentedImagesToCurrentCommentedImages(List<File> newImages, List<List<CommentedImageOld>> currentCommImgs){
    _initUnsentInitialConfig(newImages, currentCommImgs);
    _defineConfigOfNewState(CmmImgDataType.UNSENT);
    return _currentState;
  }

  void _defineConfigOfNewState(CmmImgDataType dataType){
    this.currentCommImgs = _generateCommImgsPerPage();
    _generateState(dataType);
  }

  void _initUnsentInitialConfig(List<File> newImages, List<List<CommentedImageOld>> currentCommImgs){
    this.newImages = newImages;
    this.currentCommImgs = currentCommImgs;
    _newCommentedImages = _transformToCommentedImages();
    _defineNPages(_newCommentedImages.length);
  }

  List<CommentedImageOld> _transformToCommentedImages(){
    final List<CommentedImageOld> commImages = [];
    currentCommImgs.forEach((List<CommentedImageOld> commImgsForOnePage) {
      commImages.addAll(commImgsForOnePage);
    });
    final List<CommentedImageOld> newCommImages = this.newImages.map<CommentedImageOld>(
      (File image) =>  UnSentCommentedImageOld(image: image, commentary: '')
    ).toList();
    commImages.addAll(newCommImages);
    return commImages;
  }

  void _defineNPages(int totalListLength){
    final double unExactlyNPages = _newCommentedImages.length /_nCommImgsPerPage;
    _currentNPages = unExactlyNPages.ceil();
  }

  List<List<CommentedImageOld>> _generateCommImgsPerPage(){
    final List<List<CommentedImageOld>> commImagesWidgetsPerPage = [];
    for(int pageIndex = 0; pageIndex < _currentNPages; pageIndex++){
      final List<CommentedImageOld> commImgsOfCurrentPage = _createCommImgsForCurrentPage(pageIndex);
      commImagesWidgetsPerPage.add(commImgsOfCurrentPage);
    }
    return commImagesWidgetsPerPage;
  }

  List<CommentedImageOld> _createCommImgsForCurrentPage(int pageIndex){
    final List<CommentedImageOld> commImgsOfCurrentPage = [];
    final int sobrante = _definirSobranteDeUltimaPageIndex(pageIndex);
    for(int j = 0; j < _nCommImgsPerPage - sobrante; j++){
      final CommentedImageOld commImage = _newCommentedImages[pageIndex*_nCommImgsPerPage + j];
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

  CommentedImagesState generateSentCommentedImagesByPage(List<CommentedImageOld> commentedImages){
    _initSentInitialConfig(commentedImages);
    _defineConfigOfNewState(CmmImgDataType.SENT);
    return _currentState;
  }

  void _initSentInitialConfig(List<CommentedImageOld> commentedImages){
    this.currentCommImgs = [];
    _newCommentedImages = commentedImages;
    _defineNPages(_newCommentedImages.length);
  }
}