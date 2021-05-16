part of 'muestras_bloc.dart';

abstract class MuestrasState extends Equatable {
  const MuestrasState();
  
  @override
  List<Object> get props => [this.runtimeType];
}

class MuestreoEmpty extends MuestrasState {}

class LoadingMuestreo extends MuestrasState {}

abstract class LoadedMuestreo extends MuestrasState{
  final Muestreo muestreo;
  LoadedMuestreo({
    @required this.muestreo
  });
  @override
  List<Object> get props => [...super.props, this.muestreo];
}

class OnPreparacionMuestra extends LoadedMuestreo{
  OnPreparacionMuestra({
    @required Muestreo muestra
  }):super(
    muestreo: muestra
  );
}

class OnEleccionTomaOFinalizar extends LoadedMuestreo{
  OnEleccionTomaOFinalizar({
    @required Muestreo muestreo
  }):super(
    muestreo: muestreo
  );
}

class OnChosingRangoEdad extends LoadedMuestreo{
  OnChosingRangoEdad({
    @required Muestreo muestreo
  }):super(
    muestreo: muestreo
  );
}

class OnTomaPesos extends LoadedMuestreo{
  final int rangoEdadIndex;
  OnTomaPesos({
    @required this.rangoEdadIndex,
    @required Muestreo muestreo
  }):super(
    muestreo: muestreo
  );
  @override
  List<Object> get props => [...super.props, this.rangoEdadIndex];
}

class OnEditingMuestra extends LoadedMuestreo{
  final Muestra muestra;
  final int indexMuestra;
  final List<double> pesosEsperados;

  OnEditingMuestra({
    @required this.muestra,
    @required this.indexMuestra,
    @required this.pesosEsperados,
    @required Muestreo muestreo
  }):super(
    muestreo: muestreo
  );

  @override
  List<Object> get props => [...super.props, this.muestra, this.pesosEsperados];
}

class OnMuestraDetail extends LoadedMuestreo{
  final Muestra muestra;

  OnMuestraDetail({
    @required this.muestra,
    @required Muestreo muestreo
  }):super(muestreo: muestreo);

  @override
  List<Object> get props => [...super.props, this.muestra];
}

class MuestraRemoved extends LoadedMuestreo{
  MuestraRemoved({
    @required Muestreo muestreo
  }):super(muestreo: muestreo);
}

class MuestraError extends MuestrasState{
  final String message;

  MuestraError({
    @required this.message
  });

  @override
  List<Object> get props => [this.message];
}