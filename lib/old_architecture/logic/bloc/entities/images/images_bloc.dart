import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'images_event.dart';
part 'images_state.dart';

class ImagesOldBloc extends Bloc<ImagesEvent, ImagesState> {
  ImagesState _currentStateToYield;
  ImagesOldBloc() : super(ImagesState());

  @override
  Stream<ImagesState> mapEventToState(
    ImagesEvent event,
  ) async* {
    if(event is LoadPhoto){
      loadPhoto(event);
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
  void resetAll(){
    _currentStateToYield = ImagesState();
  }
}
