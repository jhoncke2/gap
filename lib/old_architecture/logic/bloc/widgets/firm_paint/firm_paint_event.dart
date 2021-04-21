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

class ResetFirmPaint extends FirmPaintEvent{}

class AddFirmPainter extends FirmPaintEvent{
  final FirmPainter painter;
  AddFirmPainter({
    @required this.painter
  });
}
