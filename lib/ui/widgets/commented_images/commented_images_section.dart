import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/blocs_manager/commented_images_index_manager.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/commented_images/commented_image_card.dart';
import 'package:gap/ui/widgets/unloaded_elements/unloaded_nav_items.dart';



class CommentedImagesPag extends StatelessWidget{

  @override
  Widget build(BuildContext context) {   
    return BlocBuilder<IndexBloc, IndexState>(
      builder: (context, indexState) {
        _verificarActivacionIndex();
        return BlocBuilder<CommentedImagesBloc, CommentedImagesState>(
          builder: (_, commImgsWidgtsState) {
            if(commImgsWidgtsState.nPaginasDeCommImages == 0){
              return UnloadedNavItems();
            }else{
              return _LoadedCommentedImagesPag(indexState: indexState, commImgsWidgetsState: commImgsWidgtsState);
            }
          },
        );
      },
    );
  }

  void _verificarActivacionIndex(){
    CommentedImagesIndexManagerSingleton.commImgIndexManager.definirActivacionAvanzarSegunCommentedImages();
  }
}

class _LoadedCommentedImagesPag extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final List<FocusNode> _cardsInputsFocuses = [];
  final IndexState indexState;
  final CommentedImagesState commImgsWidgetsState;
  _LoadedCommentedImagesPag({
    @required this.indexState,
    @required this.commImgsWidgetsState,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.6,
      child: Column(
        children:_createCommentedImages(),
      ),
    );
  }

  List<Widget> _createCommentedImages(){
    
    final int currentIndex = indexState.currentIndexPage;
    final List<CommentedImage> commImages = commImgsWidgetsState.getCommImgsByIndex(currentIndex);
    final List<Widget> commentedImagesCards = [];
    for(int i = 0; i < commImages.length; i++){
      final CommentedImage commImg = commImages[i];
      final FocusNode focusNode = FocusNode();
      final Key cardKey = ObjectKey(commImg);
      final CommentedImageCard commImgCard = CommentedImageCard(commentedImage: commImg, focusNode: focusNode, key: cardKey);
      commentedImagesCards.add(commImgCard);
    }
    /*
    final List<Widget> commentedImagesCards = commImages.map<CommentedImageCard>(
      (CommentedImage commImg){
        //_cardsInputsFocuses
        return CommentedImageCard(commentedImage: commImg, key: new Key());
      }
    ).toList();
    */
    return commentedImagesCards;
  }
}