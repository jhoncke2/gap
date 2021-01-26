import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/widgets/commented_images_widgets/commented_images_widgets_bloc.dart';
import 'package:gap/bloc/widgets/index/index_bloc.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/unloaded_elements/unloaded_nav_items.dart';

class CommentedImagesPag extends StatelessWidget {
  CommentedImagesPag();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndexBloc, IndexState>(
      builder: (context, indexState) {
        return BlocBuilder<CommentedImagesWidgetsBloc, CommentedImagesWidgetsState>(
          builder: (_, commImgsWidgtsState) {
            if(commImgsWidgtsState is CommentedImagesWidgetsInitialState){
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
  final CommentedLoadedImagesWidgetsState commImgsWidgetsState;
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
    final List<Widget> commentedImages = commImgsWidgetsState.getWidgetsByIndex(currentIndex);
    return commentedImages;
  }
}