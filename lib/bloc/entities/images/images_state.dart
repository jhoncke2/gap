part of 'images_bloc.dart';

@immutable
class ImagesState {
  final bool thereArePhotos;
  final List<File> photos;
  final List<File> currentPhotosToSet;

  ImagesState({
    this.thereArePhotos = false, 
    List<File> photos,
    List<File> currentPhotosToSet
  }):
    this.photos = photos??[],
    this.currentPhotosToSet = currentPhotosToSet??[]
  ;

  ImagesState copyWith({
    bool thereArePhotos,
    List<File> photos,
    List<File> currentPhotosToSet
  }) => ImagesState(
    thereArePhotos:thereArePhotos??this.thereArePhotos,
    photos:photos??this.photos,
    currentPhotosToSet:currentPhotosToSet??this.currentPhotosToSet
  );
}
