part of 'muestras_bloc.dart';

abstract class MuestrasState extends Equatable {
  const MuestrasState();
  
  @override
  List<Object> get props => [this.runtimeType];
}

class MuestraEmpty extends MuestrasState {}

class LoadingMuestra extends MuestrasState{}

abstract class LoadedMuestra extends MuestrasState{
  final Muestreo muestra;
  LoadedMuestra({
    @required this.muestra
  });
  @override
  List<Object> get props => [...super.props, this.muestra];
}

class OnPreparacionMuestra extends LoadedMuestra{
  OnPreparacionMuestra({
    @required Muestreo muestra
  }):super(
    muestra: muestra
  );
}

class OnEleccionTomaOFinalizar extends LoadedMuestra{
  OnEleccionTomaOFinalizar({
    @required Muestreo muestra
  }):super(
    muestra: muestra
  );
  
}

class OnChosingRangoEdad extends LoadedMuestra{
  OnChosingRangoEdad({
    @required Muestreo muestra
  }):super(
    muestra: muestra
  );
}

class OnTomaPesos extends LoadedMuestra{
  final int rangoEdadIndex;
  OnTomaPesos({
    @required this.rangoEdadIndex,
    @required Muestreo muestra
  }):super(
    muestra: muestra
  );
  @override
  List<Object> get props => [...super.props, this.rangoEdadIndex];
}

class MuestraError extends MuestrasState{
  final String message;

  MuestraError({
    @required this.message
  });

  @override
  List<Object> get props => [this.message];
}
