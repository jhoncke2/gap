import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/firm_paint/firm_paint_bloc.dart';
// ignore: must_be_immutable
class FirmPaint extends StatelessWidget{
  FirmPaintState _firmPaintState;
  FirmPainter _firmPainter;
  final Size size;
  FirmPaint({
    @required this.size
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height, 
      child: BlocBuilder<FirmPaintBloc, FirmPaintState>(
        builder: (context, state){
          _initInitialConfig(context, state);
          return CustomPaint(
            painter: _firmPainter,
            willChange: true,
          );
        },
      ),
    );
  }

  _initInitialConfig(BuildContext context, FirmPaintState state){
    _firmPaintState = state;
    final List<List<Offset>> pointsByWord = state.pointsByWord;
    _firmPainter = FirmPainter(context: context, pointsByWord: pointsByWord);
    if(_firmPaintState.firmPainter == null){
      final FirmPaintBloc fpBloc = BlocProvider.of<FirmPaintBloc>(context);
      final AddFirmPainter afpEvent = AddFirmPainter(painter: _firmPainter);
      fpBloc.add(afpEvent);
    }
  }
}

class FirmPainter extends CustomPainter{
  final BuildContext context;
  final List<List<Offset>> pointsByWord;
  Canvas _canvas;
  Size _size;
  Paint _paint;
  FirmPainter({
    @required this.context,
    @required this.pointsByWord
  });

  @override
  void paint(Canvas canvas, Size size) {
    _initInitialConfig(canvas, size);
    for (List<Offset> currentWord in pointsByWord) {
      if(currentWord.length == 1){
        _paintPoint(currentWord[0]);
      }else{
        _paintWord(currentWord);
      }
    }
  }

  void _paintWord(List<Offset> word){
    for (int i = 0; i < word.length; i++) {
      _paintCoupleOfPoints(word, i);
    }
  }

  void _initInitialConfig(Canvas canvas, Size size) {
    _canvas = canvas;
    _size = size;
    _paint = Paint();
    _paint.color = Colors.black;
    _paint.strokeWidth = 1.2;
  }

  void _paintPoint(Offset currentPoint){
    if(!pointIsInsidePainterSpace(currentPoint))
      return;
    _paint.strokeWidth = 1.75;
    _canvas.drawPoints(PointMode.points, [currentPoint], _paint);
    _paint.strokeWidth = 1.2;
  }

  void _paintCoupleOfPoints(List<Offset> currentWord, int pointIndex) {
    if (currentWord.length > pointIndex + 1) {
      final Offset p1 = currentWord[pointIndex];
      final Offset p2 = currentWord[pointIndex + 1];
      if(!pointIsInsidePainterSpace(p1) || !pointIsInsidePainterSpace(p2))
        return;
      _canvas.drawLine(p1, p2, _paint);
    }
  }

  bool pointIsInsidePainterSpace(Offset point){
    return _size.contains(point);
  }

  @override
  bool shouldRepaint(FirmPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(FirmPainter oldDelegate) => true;
  
}
