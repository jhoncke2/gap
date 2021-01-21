part of 'adjuntar_imgs_a_visit_bloc.dart';

@immutable
class AdjuntarImgsAVisitState {
  final bool thereArePhotos;
  final List<File> photos;
  final List<File> currentPhotosToSet;

  AdjuntarImgsAVisitState({
    this.thereArePhotos = false, 
    this.photos, 
    this.currentPhotosToSet
  });

  AdjuntarImgsAVisitState copyWith({
    bool thereArePhotos,
    List<File> photos,
    List<File> currentPhotosToSet
  }) => AdjuntarImgsAVisitState(
    thereArePhotos:thereArePhotos??this.thereArePhotos,
    photos:photos??this.photos,
    currentPhotosToSet:currentPhotosToSet??this.currentPhotosToSet
  );

}
