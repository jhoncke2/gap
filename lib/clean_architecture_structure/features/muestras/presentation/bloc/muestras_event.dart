part of 'muestras_bloc.dart';

abstract class MuestrasEvent extends Equatable {
  const MuestrasEvent();
  @override
  List<Object> get props => [];
}

class GetMuestraEvent extends MuestrasEvent{}

class SetMuestraPreparaciones extends MuestrasEvent{
  final List<String> preparaciones;
  SetMuestraPreparaciones({
    @required this.preparaciones
  });
}

class AddNewTomaDeMuestra extends MuestrasEvent{ }

class ChooseRangoEdad extends MuestrasEvent{
  final String rango;
  ChooseRangoEdad({
    @required this.rango
  });
}

class AddTomaPesosMuestra extends MuestrasEvent{
  final List<String> pesos;
  AddTomaPesosMuestra({
    @required this.pesos
  });
}

class SetMuestraEvent extends MuestrasEvent{
  final Muestra muestra;
  SetMuestraEvent({
    @required this.muestra
  });
}