import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/firm_paint/firm_paint_bloc.dart';
// ignore: must_be_immutable
class DrawDetector extends StatelessWidget {
  FirmPaintBloc _firmPaintBloc;
  final Size size;
  DrawDetector({
    @required this.size
  });

  @override
  Widget build(BuildContext context) {
    _initInitialConfig(context);
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        width: size.width,
        height: size.height,
      ),
      onPanDown: (DragDownDetails details){
        _createWord();
        _addPointToCurrentWord(details.localPosition);
      },
      onPanStart: (DragStartDetails details) {
        _addPointToCurrentWord(details.localPosition);
      },
      onPanUpdate: (DragUpdateDetails details) {
        _addPointToCurrentWord(details.localPosition);
      },
    );
  }

  void _initInitialConfig(BuildContext context){
    _firmPaintBloc = BlocProvider.of<FirmPaintBloc>(context);
  }

  void _createWord(){
    _firmPaintBloc.add(AddNewWord());
  }

  void _addPointToCurrentWord(Offset position){
    AddNewPointToCurrentWord anptcwEvent = AddNewPointToCurrentWord(newPoint: position);
    _firmPaintBloc.add(anptcwEvent);
  }
}