import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'firm_paint_event.dart';
part 'firm_paint_state.dart';

class FirmPaintBloc extends Bloc<FirmPaintEvent, FirmPaintState> {
  FirmPaintState _currentStateToYield;
  FirmPaintBloc() : super(FirmPaintState());

  @override
  Stream<FirmPaintState> mapEventToState(
    FirmPaintEvent event,
  ) async* {
    if(event is AddNewPointToCurrentWord){
      _addNewPointToCurrentWord(event);
    }
    if(event is AddNewWord){
      _addNewWord(event);
    }
    if(event is ResetAllOffFirmPaint){
      _resetAllOffFirmPaint(event);
    }
    yield _currentStateToYield;
  }

  void _addNewPointToCurrentWord(AddNewPointToCurrentWord event){
    final Offset newPoint = event.newPoint;
    final List<List<Offset>> pointsByWord = state.pointsByWord;
    final List<Offset> lastWordPoints = pointsByWord[pointsByWord.length - 1];
    lastWordPoints.add(newPoint);
    _currentStateToYield = state.copyWith(
      pointsByWord: pointsByWord
    );
  }

  void _addNewWord(AddNewWord event){
    final List<List<Offset>> pointsByWord = state.pointsByWord;
    pointsByWord.add(List<Offset>());
    _currentStateToYield = state.copyWith(
      pointsByWord: pointsByWord
    );
  }

  void _resetAllOffFirmPaint(ResetAllOffFirmPaint event){
    _currentStateToYield = FirmPaintState();
  } 

}
