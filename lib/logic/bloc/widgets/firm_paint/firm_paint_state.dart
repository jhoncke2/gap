part of 'firm_paint_bloc.dart';


class FirmPaintState {
  final List<List<Offset>> pointsByWord;

  FirmPaintState({
    List<List<Offset>> pointsByWord
  }):
    this.pointsByWord = pointsByWord??[]
    ;

  FirmPaintState copyWith({
    List<List<Offset>> pointsByWord
  })=>FirmPaintState(
    pointsByWord: pointsByWord??this.pointsByWord
  );
}
