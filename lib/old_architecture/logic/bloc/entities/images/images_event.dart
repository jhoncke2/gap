part of 'images_bloc.dart';

@immutable
abstract class ImagesEvent {}

class LoadPhoto extends ImagesEvent{
  final File photo;
  LoadPhoto({
    @required this.photo
  });
}

class SetPhotos extends ImagesEvent{
  final List<File> photos;
  SetPhotos({
    @required this.photos
  });
}

class ResetImages extends ImagesEvent{}