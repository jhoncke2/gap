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

class AddNewMuestra extends MuestrasEvent{

}

class ChooseRangoEdad extends MuestrasEvent{

}

class AddTomaPesosMuestra extends MuestrasEvent{
  final List<double> pesos;
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

class ChangeMuestrasStep extends MuestrasEvent{
  final MuestrasStep step;
  ChangeMuestrasStep({
    @required this.step
  });
}
