part of 'muestras_bloc.dart';

abstract class MuestrasEvent extends Equatable {
  const MuestrasEvent();
  @override
  List<Object> get props => [];
}

class GetMuestreoEvent extends MuestrasEvent{}

class SetMuestreoPreparaciones extends MuestrasEvent{
  final List<String> preparaciones;
  SetMuestreoPreparaciones({
    @required this.preparaciones
  });
}

class InitNewMuestra extends MuestrasEvent{ }

class ChooseRangoEdad extends MuestrasEvent{
  final int rangoIndex;
  ChooseRangoEdad({
    @required this.rangoIndex
  });
}

class AddMuestraPesos extends MuestrasEvent{
  final List<String> pesos;
  AddMuestraPesos({
    @required this.pesos
  });
}

class SetMuestraEvent extends MuestrasEvent{
  final Muestreo muestra;
  SetMuestraEvent({
    @required this.muestra
  });
}