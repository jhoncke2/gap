part of 'firm_paint_bloc.dart';


class FirmPaintState {
  final int nTotalPoints;
  final List<List<Offset>> pointsByWord;

  FirmPaintState({
    List<List<Offset>> pointsByWord,
    this.nTotalPoints = 0
  }):
    this.pointsByWord = pointsByWord??[]
    ;

  FirmPaintState copyWith({
    List<List<Offset>> pointsByWord,
    int nTotalPoints
  })=>FirmPaintState(
    pointsByWord: pointsByWord??this.pointsByWord,
    nTotalPoints: nTotalPoints??this.nTotalPoints
  );
}
