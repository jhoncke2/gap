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
      _loadPhoto(event);
    }else if(event is SetPhotos){
      _setPhotos(event);
    }else if(event is ResetAllImages){
      _resetAll();
    }
    yield _currentStateToYield;
  }

  void _loadPhoto(LoadPhoto event){
    final File photo = event.photo;
    final List<File> currentPhotosToSet = state.currentPhotosToSet;
    currentPhotosToSet.add(photo);
    _currentStateToYield = state.copyWith(
      currentPhotosToSet: currentPhotosToSet
    );
  }

  void _setPhotos(SetPhotos event){
    final List<File> newPhotos = event.photos;
    final List<File> photos = state.photos;
    photos.addAll(newPhotos);
    _currentStateToYield = state.copyWith(
      photos: photos
    );
  }

  void _resetAll(){
    _currentStateToYield = ImagesState();
  }
}
