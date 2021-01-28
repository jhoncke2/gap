import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/models/entities/commented_image.dart';
import 'package:gap/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class CommentedImageCard extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final TextEditingController _commentaryController;
  final CommentedImage commentedImage;
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
    final IndexBloc indexBloc = BlocProvider.of<IndexBloc>(_context);
    _currentIndex = indexBloc.state.currentIndex;
    //Para que el cursor aparezca en la parte derecha del texto
    _commentaryController.selection = TextSelection.fromPosition(TextPosition(offset: _commentaryController.text.length));
  }

  Widget _createImage(){
    return Image.file(
      commentedImage.image,
      height: _sizeUtils.xasisSobreYasis * 0.14,
      width: _sizeUtils.xasisSobreYasis * 0.14,
      fit: BoxFit.cover,
    );
  }

  Widget _createComentaryInput(){
    return Container(
      width: _sizeUtils.xasisSobreYasis * 0.415,
      child: TextFormField(
        controller: _commentaryController,
        //focusNode: focusNode,
        //key: this.key,
        maxLines: 4,
        decoration: _createCommentaryDecoration(),
        onChanged: _onInputChanged,
        textAlign: TextAlign.start,
        onEditingComplete: _onEditingComplete,
        keyboardType: TextInputType.multiline,
        keyboardAppearance: Brightness.dark,
      ),
    );
  }

  void _onInputChanged(String newValue){
    commentedImage.commentary = newValue;
    final CommentImage commImgEvent = CommentImage(
      commentary: newValue, 
      page: _currentIndex,
      positionInPage: commentedImage.positionInPage, 
    );
    _commImgsBloc.add(commImgEvent);
    
  }

  void _onInputSubmitted(String value){
    print('on submitted');
  }

  void _onEditingComplete(){
    print('on editing complete');
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