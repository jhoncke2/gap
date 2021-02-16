import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:gap/logic/storage_managers/index/index_storage_manager.dart';
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
    if(event is ChangeSePuedeAvanzar){
      _changeSePuedeAvanzar(event);
    }else if(event is ChangeIndexPage){
      _changeIndex(event);
    }else if(event is ChangeNPages){
      _cnahgeNPages(event);
    }else if(event is ResetAllOfIndex){
      _resetAllOfIndex();
    }
    yield _currentStateToYield;
    
  }

  void _changeSePuedeAvanzar(ChangeSePuedeAvanzar event){
    final bool sePuedeAvanzar = event.sePuede;
    _currentStateToYield = state.copyWith(sePuedeAvanzar: sePuedeAvanzar);
    IndexStorageManager.setIndex(_currentStateToYield);
  }

  void _changeIndex(ChangeIndexPage event){
    final int newIndex = event.newIndexPage;
    _currentStateToYield = state.copyWith(
      currentIndex: newIndex,
    );
    _revisarActivacionesNavegacion();
    IndexStorageManager.setIndex(_currentStateToYield);
  }

  void _cnahgeNPages(ChangeNPages event){
    final int nPages = event.nPages;
    int currentIndex = _getValueToCurrentIndex();
    _currentStateToYield = state.copyWith(
      nPages: nPages,
      currentIndex: currentIndex
    );
    IndexStorageManager.setIndex(_currentStateToYield);
  }

  int _getValueToCurrentIndex(){
    final int currentIndex = state.currentIndexPage;
    if(currentIndex == -1)
      return 0;
    return currentIndex;
  }

  void _revisarActivacionesNavegacion(){
    bool sePuedeAvanzar = true;
    bool sePuedeRetroceder = true;
    final int currentIndex = _currentStateToYield.currentIndexPage;
    if(currentIndex == 0){
      sePuedeRetroceder = false;
    }else if(currentIndex == _currentStateToYield.nPages - 1){
      sePuedeAvanzar = false;
    }
    _currentStateToYield = _currentStateToYield.copyWith(
      sePuedeAvanzar: sePuedeAvanzar,
      sePuedeRetroceder: sePuedeRetroceder
    );
  }

  void _resetAllOfIndex(){
    _currentStateToYield = IndexState();
    IndexStorageManager.removeIndex();
  }
}
