import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/models/ui/commented_image.dart';
import 'package:gap/ui/utils/size_utils.dart';
import 'package:gap/ui/widgets/commented_images/commented_image_card.dart';
import 'package:gap/ui/widgets/unloaded_elements/unloaded_nav_items.dart';

class CommentedImagesPag extends StatelessWidget {
  CommentedImagesPag();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndexBloc, IndexState>(
      builder: (context, indexState) {
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
}

class _LoadedCommentedImagesPag extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
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
    final int currentIndex = indexState.currentIndex;
    final List<CommentedImage> commImages = commImgsWidgetsState.getWidgetsByIndex(currentIndex);
    final List<Widget> commentedImages = commImages.map<CommentedImageCard>(
      (CommentedImage commImg) => CommentedImageCard(commentedImage: commImg)
    ).toList();
    return commentedImages;
  }
}