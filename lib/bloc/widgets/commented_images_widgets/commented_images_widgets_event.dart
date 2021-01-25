part of 'commented_images_widgets_bloc.dart';

@immutable
abstract class CommentedImagesWidgetsEvent {}

class AddImages extends CommentedImagesWidgetsEvent{
  final List<File> images;
  AddImages({
    @required this.images
  });
}

class ResetAllCommentedImages extends CommentedImagesWidgetsEvent{}