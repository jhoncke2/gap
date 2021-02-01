part of 'firm_paint_bloc.dart';

@immutable
abstract class FirmPaintEvent {}

class AddNewPointToCurrentWord extends FirmPaintEvent{
  final Offset newPoint;
  AddNewPointToCurrentWord({
    @required this.newPoint
  });
}

class AddNewWord extends FirmPaintEvent{}

class ResetAllOffFirmPaint extends FirmPaintEvent{}
