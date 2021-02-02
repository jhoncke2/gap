import 'dart:ui';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/models/entities/commented_image.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/firm_field/firm_paint.dart';
import 'package:path_provider/path_provider.dart';
class CommentedImagesIndexManagerSingleton{
  static final CommentedImagesIndexManagerSingleton _commImgsIndxManagerSingleton = CommentedImagesIndexManagerSingleton._internal();
  static final CommentedImagesIndexManager commImgIndexManager = CommentedImagesIndexManager();
  CommentedImagesIndexManagerSingleton._internal();

  factory CommentedImagesIndexManagerSingleton({
    @required BuildContext appContext
  }){
    _initInitialElements(appContext);
    return _commImgsIndxManagerSingleton;
  }
  
  static void _initInitialElements(BuildContext appContext){
    commImgIndexManager..appContext = appContext
    ..commImgsBloc = BlocProvider.of<CommentedImagesBloc>(appContext)
    ..indexBloc = BlocProvider.of<IndexBloc>(appContext);
    print(commImgIndexManager);
  }

  @protected
  factory CommentedImagesIndexManagerSingleton.forTesting({
    @required BuildContext appContext,
    @required CommentedImagesBloc commImgsBloc, 
    @required IndexBloc indexBloc,
  }){
    _initInitialTestingElements(appContext, commImgsBloc, indexBloc);
    return _commImgsIndxManagerSingleton;
  }

  static void _initInitialTestingElements(BuildContext appContext, CommentedImagesBloc commImgsBloc, IndexBloc indexBloc){
    commImgIndexManager..appContext = appContext
    ..commImgsBloc = commImgsBloc
    ..indexBloc = indexBloc;
  }
  // ****************** Fin del modelo Singleton
}


class CommentedImagesIndexManager{
  BuildContext appContext;
  CommentedImagesBloc commImgsBloc;
  IndexBloc indexBloc;

  bool allCommentedImagesAreCompleted(){
    final int nPages = indexBloc.state.nPages;
    for(int index = 0; index < nPages; index++){
      final List<CommentedImage> commImagesForCurrentIndxPage = commImgsBloc.state.getCommImgsByIndex(index);
      for(CommentedImage commImg in commImagesForCurrentIndxPage){
        if([null, ''].contains(commImg.commentary)){
          return false;
        }
      }
    }
    return true;
  }

  void definirActivacionAvanzarSegunCommentedImages(){
    try{
      _tryDefinirActivacionAvanzarSegunCommentedImages();
    }catch(err){
      print(err);
    }
  }

  void _tryDefinirActivacionAvanzarSegunCommentedImages(){
    if(indexBloc.state.nPages > 0){
      _doDefinitionOfActivation();
    }
  }

  void _doDefinitionOfActivation(){
    final int currentIndex = indexBloc.state.currentIndex;
    final CommentedImagesState commImgsState = commImgsBloc.state;
    final List<CommentedImage> commImgsByIndex = commImgsState.getCommImgsByIndex(currentIndex);
    bool sePuedeAvanzar = _definirSiSePuedeAvanzar(commImgsByIndex);
    if(indexBloc.state.sePuedeAvanzar != sePuedeAvanzar){
      _changeSePuedeAvanzar(sePuedeAvanzar);
    }
  }

  bool _definirSiSePuedeAvanzar(List<CommentedImage> commImgsByIndex){
    for(CommentedImage commImg in commImgsByIndex){
      if([null, ''].contains(commImg.commentary)){
        return false;
      }
    }
    return true;
  }

  void _changeSePuedeAvanzar(bool sePuedeAvanzar){
    final ChangeSePuedeAvanzar sePuedeAvanzEvent = ChangeSePuedeAvanzar(sePuede: sePuedeAvanzar);
    indexBloc.add(sePuedeAvanzEvent);
  }
}