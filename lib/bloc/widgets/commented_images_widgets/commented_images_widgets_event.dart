part of 'commented_images_widgets_bloc.dart';

@immutable
abstract class CommentedImagesWidgetsEvent {
  final bool hasOnEndFunction;
  final Function onEnd;
  CommentedImagesWidgetsEvent({
    this.hasOnEndFunction = false,
    this.onEnd
  });
}

class AddImages extends CommentedImagesWidgetsEvent{
  final List<File> images;
  AddImages({
    @required this.images,
    @required Function onEnd
  }):
    super(hasOnEndFunction: true, onEnd: onEnd)
    ;
}

class ResetAllCommentedImages extends CommentedImagesWidgetsEvent{}