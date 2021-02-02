import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/firm_paint/firm_paint_bloc.dart';
class FirmPaint extends StatelessWidget{
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
        builder: (context, state) {
          return CustomPaint(
            painter: FirmPainter(firmPaintSate: state),
            willChange: true,
          );
        },
      ),
    );
  }
}

class FirmPainter extends CustomPainter {
  final FirmPaintState firmPaintSate;
  Canvas _canvas;
  Size _size;
  Paint _paint;
  FirmPainter({
    @required this.firmPaintSate
  });

  @override
  void paint(Canvas canvas, Size size) {
    _initInitialConfig(canvas, size);
    for (List<Offset> currentWord in firmPaintSate.pointsByWord) {
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
  bool shouldRebuildSemantics(FirmPainter oldDelegate) => false;
}
