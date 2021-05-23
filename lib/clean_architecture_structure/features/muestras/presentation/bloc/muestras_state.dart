part of 'muestras_bloc.dart';

abstract class MuestrasState extends Equatable {
  const MuestrasState();
  
  @override
  List<Object> get props => [this.runtimeType];
}

class OnChooseInitOrEndMuestreo extends MuestrasState {}

class LoadingMuestreo extends MuestrasState {}

abstract class LoadedMuestreo extends MuestrasState{
  final Muestreo muestreo;
  LoadedMuestreo({
    @required this.muestreo
  });
  @override
  List<Object> get props => [...super.props, this.muestreo];
}

class OnChooseMuestreoStep extends LoadedMuestreo {
  OnChooseMuestreoStep({
    @required Muestreo muestreo
  }):super(
    muestreo: muestreo
  );
}

class OnPreparacionMuestreo extends LoadedMuestreo{
  OnPreparacionMuestreo({
    @required Muestreo muestreo
  }):super(
    muestreo: muestreo
  );
}

class OnChooseRangosAUsar extends LoadedMuestreo{
  OnChooseRangosAUsar({
    @required Muestreo muestreo
  }):super(
    muestreo: muestreo
  );
}

class OnChooseAddMuestraOFinalizar extends LoadedMuestreo{
  OnChooseAddMuestraOFinalizar({
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
  final int rangoId;
  OnTomaPesos({
    @required this.rangoId,
    @required Muestreo muestreo
  }):super(
    muestreo: muestreo
  );
  @override
  List<Object> get props => [...super.props, this.rangoId];
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