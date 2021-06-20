part of 'formularios_bloc.dart';

abstract class FormulariosState extends Equatable {
  const FormulariosState();
  
  @override
  List<Object> get props => [this.runtimeType];
}

class FormulariosEmpty extends FormulariosState {}

class LoadingFormularios extends FormulariosState {}

class LoadingFormulariosError extends FormulariosState{
  final String message;
  LoadingFormulariosError({
    @required this.message
  });
  @override
  List<Object> get props => [this.message];
}

class OnLoadedFormularios extends FormulariosState{
  final List<Formulario> formularios;
  OnLoadedFormularios({
    @required this.formularios
  });
  @override
  List<Object> get props => [this.formularios];
}

class LoadingFormularioSelection extends FormulariosState{}
class OnFormularioSelected extends FormulariosState{
  final Formulario formulario;
  OnFormularioSelected({
    @required this.formulario
  });
  @override
  List<Object> get props => [this.formulario];
}