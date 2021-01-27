import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/models/ui/commented_image.dart';
class CommentedImagesIndexManagerSingleton{
  static final CommentedImagesIndexManagerSingleton _csManagerSingleton = CommentedImagesIndexManagerSingleton._internal();
  static final CommentedImagesIndexManager csManager = CommentedImagesIndexManager();
  CommentedImagesIndexManagerSingleton._internal();

  factory CommentedImagesIndexManagerSingleton({
    @required BuildContext appContext
  }){
    _initInitialElements(appContext);
    return _csManagerSingleton;
  }
  
  static void _initInitialElements(BuildContext appContext){
    csManager..appContext = appContext
    ..commImgsWidgetsBloc = BlocProvider.of<CommentedImagesBloc>(appContext)
    ..indexBloc = BlocProvider.of<IndexBloc>(appContext);
    print(csManager);
  }

  @protected
  factory CommentedImagesIndexManagerSingleton.forTesting({
    @required BuildContext appContext,
    @required CommentedImagesBloc commImgsWidgetsBloc, 
    @required IndexBloc indexBloc,
  }){
    _initInitialTestingElements(appContext, commImgsWidgetsBloc, indexBloc);
    return _csManagerSingleton;
  }

  static void _initInitialTestingElements(BuildContext appContext, CommentedImagesBloc commImgsWidgetsBloc, IndexBloc indexBloc){
    csManager..appContext = appContext
    ..commImgsWidgetsBloc = commImgsWidgetsBloc
    ..indexBloc = indexBloc;
  }
  // ****************** Fin del modelo Singleton
}


class CommentedImagesIndexManager{
  BuildContext appContext;
  CommentedImagesBloc commImgsWidgetsBloc;
  IndexBloc indexBloc;

  void definirActivacionAvanzarSegunCommentedImages(){
    final int currentIndex = indexBloc.state.currentIndex;
    final CommentedImagesState commImgsState = commImgsWidgetsBloc.state;
    final List<CommentedImage> commImgsByIndex = commImgsState.getWidgetsByIndex(currentIndex);
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