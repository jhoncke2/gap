import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/firm_paint/firm_paint_bloc.dart';

// ignore: must_be_immutable
class PainterTestPage extends StatelessWidget {
  static final String route = 'painter_test';
  FirmPaintBloc _firmPaintBloc;
  PainterTestPage();

  @override
  Widget build(BuildContext context) {
    _initInitialConfig(context);
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.blueAccent.withOpacity(0.25),
          height: 300,
          width: 300,
          child: Stack(
            children: [
              _FirmPaint(),
              _createFingerDetector(),
            ],
          ),
        ),
      ),
    );
  }

  void _initInitialConfig(BuildContext context){
    _firmPaintBloc = BlocProvider.of<FirmPaintBloc>(context);
  }

  Widget _createFingerDetector() {
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        height: 300,
        width: 300,
      ),
      onTap: () {
        print('tappeado');
      },
      onPanDown: (DragDownDetails details){
        _createWord();
        _addPointToCurrentWord(details.localPosition);
        print('pandown: ${details.localPosition}');
      },
      onPanStart: (DragStartDetails details) {
        print('start: ${details.localPosition}');
        _addPointToCurrentWord(details.localPosition);
      },
      onPanUpdate: (DragUpdateDetails details) {
        print(details.localPosition);
        _addPointToCurrentWord(details.localPosition);
      },
    );
  }

  void _createWord(){
    _firmPaintBloc.add(AddNewWord());
  }

  void _addPointToCurrentWord(Offset position){
    AddNewPointToCurrentWord anptcwEvent = AddNewPointToCurrentWord(newPoint: position);
    _firmPaintBloc.add(anptcwEvent);
  }
}

class _FirmPaint extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.greenAccent,
        height: 300,
        width: 300,
        child: BlocBuilder<FirmPaintBloc, FirmPaintState>(
          builder: (context, state) {
            return CustomPaint(
              painter: _FirmPainter(firmPaintSate: state),
              willChange: true,
            );
          },
        ),
      ),
    );
  }
}

class _FirmPainter extends CustomPainter {
  final FirmPaintState firmPaintSate;
  Canvas _canvas;
  Size _size;
  Paint _paint;
  _FirmPainter({
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
  bool shouldRepaint(_FirmPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(_FirmPainter oldDelegate) => false;
}
