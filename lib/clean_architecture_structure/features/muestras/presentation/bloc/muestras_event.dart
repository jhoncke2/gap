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

class InitNewMuestra extends MuestrasEvent{}

class ChooseRangoEdad extends MuestrasEvent{
  final int rangoId;
  ChooseRangoEdad({
    @required this.rangoId
  });
}

class AddMuestraPesos extends MuestrasEvent{
  final List<String> pesos;
  AddMuestraPesos({
    @required this.pesos
  });
}

class InitMuestraEditing extends MuestrasEvent{
  final int indexMuestra;
  final Muestra muestra;

  InitMuestraEditing({
    @required this.indexMuestra, 
    @required this.muestra
  });
}

class SaveMuestraEditing extends MuestrasEvent{
  final int indexMuestra;
  final List<double> nuevosPesosTomados;

  SaveMuestraEditing({
    @required this.indexMuestra, 
    @required this.nuevosPesosTomados
  });
}

class ChooseMuestra extends MuestrasEvent{
  final Muestra muestra;

  ChooseMuestra({
    @required this.muestra
  });
}

class RemoveMuestraEvent extends MuestrasEvent {}
class BackFromMuestraDetail extends MuestrasEvent{}