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

class InitImagesCommenting extends CommentedImagesEvent{
  
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

class SetCommentedImages extends CommentedImagesEvent{
  final CmmImgDataType dataType;
  final List<UnSentCommentedImageOld> commentedImages;
  SetCommentedImages({
    @required this.dataType,
    @required this.commentedImages
  });
}

class CommentImage extends CommentedImagesEvent{
  final int page;
  final int positionInPage;
  final String commentary;
  CommentImage({
    @required this.page,
    @required this.positionInPage,
    @required this.commentary,
    @required Function onEnd
  }):super(
    hasOnEndFunction: true,
    onEnd: onEnd
  );
}

class InitSentCommImgsWatching extends CommentedImagesEvent{
  final List<CommentedImageOld> sentCommentedImages;
  InitSentCommImgsWatching({
    @required this.sentCommentedImages,
    @required Function onEnd
  }):super(
    hasOnEndFunction: true,
    onEnd: onEnd
  );
}

class ResetCommentedImages extends CommentedImagesEvent{}