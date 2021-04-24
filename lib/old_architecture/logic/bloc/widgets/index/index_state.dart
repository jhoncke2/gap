part of 'index_bloc.dart';

@immutable
class IndexState{
  final int nPages;
  final int currentIndexPage;
  final bool sePuedeAvanzar;
  final bool sePuedeRetroceder;

  IndexState({
    this.nPages = 0,
    this.currentIndexPage = -1, 
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
    currentIndexPage: currentIndex??this.currentIndexPage,
    sePuedeAvanzar: sePuedeAvanzar??this.sePuedeAvanzar,
    sePuedeRetroceder: sePuedeRetroceder??this.sePuedeRetroceder,
  );

  factory IndexState.fromJson(Map<String, dynamic> json){
    return IndexState(
      nPages: json['n_pages'],
      currentIndexPage: json['current_index'],
      sePuedeAvanzar: json['se_puede_avanzar'],
      sePuedeRetroceder: json['se_puede_retroceder']
    );
  }
}