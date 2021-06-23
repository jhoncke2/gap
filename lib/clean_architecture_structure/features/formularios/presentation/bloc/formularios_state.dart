part of 'formularios_bloc.dart';

abstract class FormulariosState extends Equatable {
  const FormulariosState();
  
  @override
  List<Object> get props => [this.runtimeType];
}

class FormulariosEmpty extends FormulariosState {}

class LoadingFormularios extends FormulariosState {}

class FormulariosLoadingError extends FormulariosState{
  final String message;
  FormulariosLoadingError({
    @required this.message
  });
  @override
  List<Object> get props => [...super.props, this.message];
}

class OnLoadedFormularios extends FormulariosState{
  final List<Formulario> formularios;
  OnLoadedFormularios({
    @required this.formularios
  });
  @override
  List<Object> get props => [...super.props, this.formularios];
}

class OnCompletedFormularios extends FormulariosState{
  
}

class LoadingFormularioSelection extends FormulariosState{}
class OnFormularioSelected extends FormulariosState{
  final Formulario formulario;
  OnFormularioSelected({
    @required this.formulario
  });
  @override
  List<Object> get props => [...super.props, this.formulario];
}

class OnFormularioDetail extends OnFormularioSelected{
  final int nFormFieldsPages;
  final int currentPage;
  final bool canAdvance;
  final bool canBack;
  final List<CustomFormFieldOld> formFieldsFromPage;
  OnFormularioDetail({
    @required this.nFormFieldsPages,
    @required this.currentPage,
    @required this.canAdvance,
    @required this.canBack,
    @required this.formFieldsFromPage,
    @required Formulario formulario,
  }):super(formulario: formulario);
  @override
  List<Object> get props => [
    ...super.props,
    this.nFormFieldsPages,
    this.currentPage,
    this.canAdvance,
    this.canBack,
    this.formFieldsFromPage
  ];
}