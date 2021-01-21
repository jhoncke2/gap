part of 'adjuntar_imgs_a_visit_bloc.dart';

@immutable
abstract class AdjuntarImgsAVisitEvent {}

class LoadPhoto extends AdjuntarImgsAVisitEvent{
  final File photo;
  LoadPhoto({
    @required this.photo
  });
}

class SetPhotos extends AdjuntarImgsAVisitEvent{
  final List<File> photos;
  SetPhotos({
    @required this.photos
  });
}
