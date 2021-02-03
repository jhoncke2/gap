part of 'firm_paint_bloc.dart';


class FirmPaintState {
  final int nTotalPoints;
  final FirmPainter firmPainter;
  final List<List<Offset>> pointsByWord;

  FirmPaintState({
    List<List<Offset>> pointsByWord,
    this.firmPainter,
    this.nTotalPoints = 0
  }):
    this.pointsByWord = pointsByWord??[]
    ;

  FirmPaintState copyWith({
    List<List<Offset>> pointsByWord,
    FirmPainter currentFirmPainter,
    int nTotalPoints
  })=>FirmPaintState(
    pointsByWord: pointsByWord??this.pointsByWord,
    firmPainter: currentFirmPainter??this.firmPainter,
    nTotalPoints: nTotalPoints??this.nTotalPoints
  );
}
