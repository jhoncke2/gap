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
    if(event is ChangeSePuedeAvanzar){
      _changeSePuedeAvanzar(event);
    }else if(event is ChangeIndex){
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
  }

  void _changeIndex(ChangeIndex event){
    final int newIndex = event.newIndex;
    _currentStateToYield = state.copyWith(
      currentIndex: newIndex,
    );
    _revisarActivacionesNavegacion();
  }

  void _cnahgeNPages(ChangeNPages event){
    final int nPages = event.nPages;
    final int currentIndex = state.currentIndex ?? 0;
    _currentStateToYield = state.copyWith(
      nPages: nPages,
      currentIndex: currentIndex
    );
  }

  void _revisarActivacionesNavegacion(){
    bool sePuedeAvanzar = true;
    bool sePuedeRetroceder = true;
    final int currentIndex = _currentStateToYield.currentIndex;
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
  }
}
