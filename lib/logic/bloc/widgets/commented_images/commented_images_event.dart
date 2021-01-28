part of 'commented_images_bloc.dart';

@immutable
abstract class CommentedImagesEvent {
  final bool hasOnEndFunction;
  final Function onEnd;
  CommentedImagesEvent({
    this.hasOnEndFunction = false,
    this.onEnd
  });
}

class AddImages extends CommentedImagesEvent{
  final List<File> images;
  AddImages({
    @required this.images,
    @required Function onEnd
  }):
    super(hasOnEndFunction: true, onEnd: onEnd)
    ;
}

class CommentImage extends CommentedImagesEvent{
  final int page;
  final int positionInPage;
  final String commentary;
  CommentImage({
    @required this.page,
    @required this.positionInPage,
    @required this.commentary 
  });
}

class ChangeEnviandoCommentedImagesAlBack extends CommentedImagesEvent{

}

class ResetAllCommentedImages extends CommentedImagesEvent{}