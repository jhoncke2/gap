part of 'muestras_bloc.dart';

abstract class MuestrasEvent extends Equatable {
  const MuestrasEvent();
  @override
  List<Object> get props => [];
}

class InitMuestreoEvent extends MuestrasEvent{}

class EndInitialFormulario extends MuestrasEvent{
  final Formulario formulario;
  EndInitialFormulario({
    @required this.formulario
  });
}

class EndTomaMuestras extends MuestrasEvent{

}

class EndFinalFormulario extends MuestrasEvent{
  final Formulario formulario;
  EndFinalFormulario({
    @required this.formulario
  });
}

class InitTomaMuestras extends MuestrasEvent{}

class SetMuestreoPreparaciones extends MuestrasEvent{
  final List<String> preparaciones;
  SetMuestreoPreparaciones({
    @required this.preparaciones
  });
}

class ChooseRangosAUsar extends MuestrasEvent{
  final List<Rango> rangos;
  ChooseRangosAUsar({
    @required this.rangos
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