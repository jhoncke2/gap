import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'images_event.dart';
part 'images_state.dart';

class ImagesBloc extends Bloc<ImagesEvent, ImagesState> {
  ImagesState _currentStateToYield;
  ImagesBloc() : super(ImagesState());

  @override
  Stream<ImagesState> mapEventToState(
    ImagesEvent event,
  ) async* {
    if(event is LoadPhoto){
      loadPhoto(event);
    }else if(event is SetPhotos){
      setPhotos(event);
    }else if(event is ResetImages){
      resetAll();
    }
    yield _currentStateToYield;
  }

  @protected
  void loadPhoto(LoadPhoto event){
    final File photo = event.photo;
    final List<File> currentPhotosToSet = state.currentPhotosToSet;
    currentPhotosToSet.add(photo);
    _currentStateToYield = state.copyWith(
      currentPhotosToSet: currentPhotosToSet
    );
  }

  @protected
  void setPhotos(SetPhotos event){
    final List<File> newPhotos = event.photos;
    final List<File> photos = state.photos;
    photos.addAll(newPhotos);
    _currentStateToYield = state.copyWith(
      photos: photos
    );
  }

  @protected
  void resetAll(){
    _currentStateToYield = ImagesState();
  }
}
