part of 'formularios_bloc.dart';

abstract class FormulariosEvent extends Equatable {
  const FormulariosEvent();
  @override
  List<Object> get props => [this.runtimeType];
}

class LoadFormularios extends FormulariosEvent{}

class SetChosenFormularioEvent extends FormulariosEvent{
  final Formulario formulario;
  SetChosenFormularioEvent({
    @required this.formulario
  });
}

class InitChosenFormularioEvent extends FormulariosEvent{
  
}