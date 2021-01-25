import 'package:flutter/material.dart';
import 'package:gap/models/ui/commented_image.dart';
import 'package:gap/utils/size_utils.dart';
// ignore: must_be_immutable
class CommentedImageCard extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final TextEditingController _commentaryController = TextEditingController();
  final CommentedImage commentedImage;
  BuildContext _context;
  CommentedImageCard({
    @required this.commentedImage,
    Key key
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      child: Row(
        children: [
          _createImage(),
          SizedBox(width:  _sizeUtils.xasisSobreYasis * 0.015),
          _createComentaryInput()
        ],
      ),
    );
  }

  Widget _createImage(){
    return Image.file(
      commentedImage.image,
      height: _sizeUtils.xasisSobreYasis * 0.1,
      width: _sizeUtils.xasisSobreYasis * 0.1,
      fit: BoxFit.cover,
    );
  }

  Widget _createComentaryInput(){
    return TextField(
      controller: _commentaryController,
      maxLines: 4,
      decoration: _createCommentaryDecoration(),
    );
  }

  InputDecoration _createCommentaryDecoration(){
    return InputDecoration(
      border: _createCommentaryBorder(),
      enabledBorder: _createCommentaryBorder()
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