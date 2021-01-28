part of 'index_bloc.dart';

@immutable
class IndexState {
  final int nPages;
  final int currentIndex;
  final bool sePuedeAvanzar;
  final bool sePuedeRetroceder;

  IndexState({
    this.nPages = 0,
    this.currentIndex = -1, 
    this.sePuedeAvanzar = false,
    this.sePuedeRetroceder = false,
  });

  IndexState copyWith({
    int nPages,
    int currentIndex,
    bool sePuedeAvanzar,
    bool sePuedeRetroceder,
   }) => IndexState(
    nPages: nPages??this.nPages,
    currentIndex: currentIndex??this.currentIndex,
    sePuedeAvanzar: sePuedeAvanzar??this.sePuedeAvanzar,
    sePuedeRetroceder: sePuedeRetroceder??this.sePuedeRetroceder,
  );
}