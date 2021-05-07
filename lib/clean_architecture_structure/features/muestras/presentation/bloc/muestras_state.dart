part of 'muestras_bloc.dart';

enum MuestrasStep{
  ON_PREPARACIONES,
  ON_ELECCION_TOMA_O_FINALIZAR,
  ON_ELEGIR_RANGO_TOMA,
  ON_PESOS_TOMADOS
}

abstract class MuestrasState extends Equatable {
  const MuestrasState();
  
  @override
  List<Object> get props => [this.runtimeType];
}

class MuestrasEmpty extends MuestrasState {}

class LoadingMuestra extends MuestrasState{}

class OnPreparacionMuestra extends MuestrasState{
   final Muestra muestra;
  OnPreparacionMuestra({
    @required this.muestra
  });
}

class OnEleccionTomaOFinalizar extends MuestrasState{
  final Muestra muestra;
  OnEleccionTomaOFinalizar({
    @required this.muestra
  });
}

class OnChosingRangoEdad{
  final Muestra muestra;
  OnChosingRangoEdad({
    @required this.muestra
  });
}

class OnTomaPesos{
  final Muestra muestra;
  final String rangoEdad;
  OnTomaPesos({
    @required this.muestra,
    @required this.rangoEdad
  });
}

class MuestraError extends MuestrasState{
  final String message;

  MuestraError({
    @required this.message
  });

  @override
  List<Object> get props => [this.message];
}
