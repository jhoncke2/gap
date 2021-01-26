import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'index_event.dart';
part 'index_state.dart';

class IndexBloc extends Bloc<IndexEvent, IndexState> {
  IndexState _currentStateToYield;
  IndexBloc() : super(IndexState());

  @override
  Stream<IndexState> mapEventToState(
    IndexEvent event,
  ) async* {
    if(event is ChangeIndexActivation){
      _changeIndexActivation(event);
    }else if(event is ChangeIndex){
      _changeIndex(event);
    }else if(event is ChangeNPages){
      _cnahgeNPages(event);
    }else if(event is ResetAllOfIndex){
      _resetAllOfIndex();
    }
    yield _currentStateToYield;
  }

  void _changeIndexActivation(ChangeIndexActivation event){
    final bool isActive = event.isActive;
    _currentStateToYield = state.copyWith(isActive: isActive);
  }

  void _changeIndex(ChangeIndex event){
    final int newIndex = event.newIndex;
    _currentStateToYield = state.copyWith(
      currentIndex: newIndex,
    );
  }

  void _cnahgeNPages(ChangeNPages event){
    final int nPages = event.nPages;
    final int currentIndex = state.currentIndex ?? 0;
    _currentStateToYield = state.copyWith(
      nPages: nPages,
      currentIndex: currentIndex
    );
  }

  void _resetAllOfIndex(){
    _currentStateToYield = IndexState();
  }
}
