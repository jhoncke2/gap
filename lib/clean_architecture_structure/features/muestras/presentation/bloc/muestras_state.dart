part of 'muestras_bloc.dart';

abstract class MuestrasState extends Equatable {
  const MuestrasState();
  
  @override
  List<Object> get props => [this.runtimeType];
}

class MuestraEmpty extends MuestrasState {}

class LoadingMuestra extends MuestrasState{}

abstract class LoadedMuestra extends MuestrasState{
  final Muestra muestra;
  LoadedMuestra({
    @required this.muestra
  });
  @override
  List<Object> get props => [...super.props, this.muestra];
}

class OnPreparacionMuestra extends LoadedMuestra{
  OnPreparacionMuestra({
    @required Muestra muestra
  }):super(
    muestra: muestra
  );
}

class OnEleccionTomaOFinalizar extends LoadedMuestra{
  OnEleccionTomaOFinalizar({
    @required Muestra muestra
  }):super(
    muestra: muestra
  );
  
}

class OnChosingRangoEdad extends LoadedMuestra{
  OnChosingRangoEdad({
    @required Muestra muestra
  }):super(
    muestra: muestra
  );
}

class OnTomaPesos extends LoadedMuestra{
  final String rangoEdad;
  OnTomaPesos({
    @required this.rangoEdad,
    @required Muestra muestra
  }):super(
    muestra: muestra
  );
  @override
  List<Object> get props => [...super.props, this.rangoEdad];
}

class MuestraError extends MuestrasState{
  final String message;

  MuestraError({
    @required this.message
  });

  @override
  List<Object> get props => [this.message];
}
