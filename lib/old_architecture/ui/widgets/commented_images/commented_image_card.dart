import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/blocs_manager/commented_images_index_manager.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class CommentedImageCard extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final TextEditingController _commentaryController;
  final CommentedImageOld commentedImage;
  final FocusNode focusNode;

  BuildContext _context;
  CommentedImagesBloc _commImgsBloc;
  int _currentIndex;

  CommentedImageCard({
    @required this.commentedImage,
    @required this.focusNode,
    Key key
  }):
    _commentaryController = TextEditingController(text: commentedImage.commentary),
    super(key: key);

  @override
  Widget build(BuildContext context){
     _initInitialConfiguration(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: _sizeUtils.xasisSobreYasis * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createImage(),
          _createComentaryInput()
        ],
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _commImgsBloc = BlocProvider.of<CommentedImagesBloc>(_context);
    final IndexOldBloc indexBloc = BlocProvider.of<IndexOldBloc>(_context);
    _currentIndex = indexBloc.state.currentIndexPage;
    //Para que el cursor aparezca en la parte derecha del texto
    _commentaryController.selection = TextSelection.fromPosition(TextPosition(offset: _commentaryController.text.length));
  }

  Widget _createImage(){
    if(commentedImage is UnSentCommentedImageOld)
      return _createFileImage(commentedImage);
    else
      return _createNetworkImage(commentedImage as SentCommentedImageOld);
  }

  Widget _createFileImage(UnSentCommentedImageOld commImg){
    return Image.file(
      commImg.image,
      height: _sizeUtils.xasisSobreYasis * 0.14,
      width: _sizeUtils.xasisSobreYasis * 0.14,
      fit: BoxFit.cover,
    );
  }

  Widget _createNetworkImage(SentCommentedImageOld commImg){
    return Image.network(
      commImg.url,
      height: _sizeUtils.xasisSobreYasis * 0.14,
      width: _sizeUtils.xasisSobreYasis * 0.14,
      fit: BoxFit.cover,
    );
  }

  Widget _createComentaryInput(){
    return Container(
      width: _sizeUtils.xasisSobreYasis * 0.415,
      child: TextFormField(
        enabled: commentedImage is UnSentCommentedImageOld,
        controller: _commentaryController,
        maxLines: 4,
        decoration: _createCommentaryDecoration(),
        onChanged: _onInputChanged,
        textAlign: TextAlign.start,
        keyboardType: TextInputType.multiline,
      ),
    );
  }

  void _onInputChanged(String newValue){
    commentedImage.commentary = newValue;
    final CommentImage commImgEvent = CommentImage(
      commentary: newValue, 
      page: _currentIndex,
      positionInPage: commentedImage.positionInPage,
      onEnd: _onEndUpdatingCommentedImages
    );
    _commImgsBloc.add(commImgEvent);
    
  }

  void _onEndUpdatingCommentedImages(){
    CommentedImagesIndexManagerSingleton.commImgIndexManager.definirActivacionAvanzarSegunCommentedImages();
  }

  InputDecoration _createCommentaryDecoration(){
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        vertical: _sizeUtils.xasisSobreYasis * 0.015,
        horizontal: _sizeUtils.xasisSobreYasis * 0.035
      ),
      border: _createCommentaryBorder(),
      enabledBorder: _createCommentaryBorder(),
    );
  }

  InputBorder _createCommentaryBorder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.065),
      borderSide: BorderSide(
        color: Theme.of(_context).primaryColor.withOpacity(0.525),
        width: 3.5
      )
    ); 
  }
}