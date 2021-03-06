import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
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
    ..indexBloc = BlocProvider.of<IndexOldBloc>(appContext);
    print(commImgIndexManager);
  }

  @protected
  factory CommentedImagesIndexManagerSingleton.forTesting({
    @required BuildContext appContext,
    @required CommentedImagesBloc commImgsBloc, 
    @required IndexOldBloc indexBloc,
  }){
    _initInitialTestingElements(appContext, commImgsBloc, indexBloc);
    return _commImgsIndxManagerSingleton;
  }

  static void _initInitialTestingElements(BuildContext appContext, CommentedImagesBloc commImgsBloc, IndexOldBloc indexBloc){
    commImgIndexManager..appContext = appContext
    ..commImgsBloc = commImgsBloc
    ..indexBloc = indexBloc;
  }
  // ****************** Fin del modelo Singleton
}


class CommentedImagesIndexManager{
  BuildContext appContext;
  CommentedImagesBloc commImgsBloc;
  IndexOldBloc indexBloc;

  bool allCommentedImagesAreCompleted(){
    final int nPages = indexBloc.state.nPages;
    for(int index = 0; index < nPages; index++){
      final List<CommentedImageOld> commImagesForCurrentIndxPage = commImgsBloc.state.getCommImgsByIndex(index);
      for(CommentedImageOld commImg in commImagesForCurrentIndxPage){
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
    final int currentIndex = indexBloc.state.currentIndexPage;
    final CommentedImagesState commImgsState = commImgsBloc.state;
    final List<CommentedImageOld> commImgsByIndex = commImgsState.getCommImgsByIndex(currentIndex).cast<CommentedImageOld>();
    bool sePuedeAvanzar = _definirSiSePuedeAvanzar(commImgsByIndex);
    if(indexBloc.state.sePuedeAvanzar != sePuedeAvanzar){
      _changeSePuedeAvanzar(sePuedeAvanzar);
    }
  }

  bool _definirSiSePuedeAvanzar(List<CommentedImageOld> commImgsByIndex){
    for(CommentedImageOld commImg in commImgsByIndex){
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