import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/get_formularios.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/set_chosen_formulario.dart';
part 'formularios_event.dart';
part 'formularios_state.dart';

class FormulariosBloc extends Bloc<FormulariosEvent, FormulariosState> {
  static const LOADING_FORMULARIOS_ERROR_MESSAGE = 'Ocurrió un error cargando los formularios';

  final GetFormularios getFormularios;
  final SetChosenFormulario setChosenFormulario;

  FormulariosBloc({
    @required this.getFormularios,
    @required this.setChosenFormulario
  }) : super(FormulariosEmpty());

  @override
  Stream<FormulariosState> mapEventToState(
    FormulariosEvent event,
  ) async* {
    if(event is LoadFormularios){
      yield LoadingFormularios();
      final eitherFormularios = await getFormularios(NoParams());
      yield * eitherFormularios.fold((_)async*{
        yield LoadingFormulariosError(message: LOADING_FORMULARIOS_ERROR_MESSAGE);
      }, (formularios)async*{
        yield OnLoadedFormularios(formularios: formularios);
      });
    }else if(event is SetChosenFormularioEvent){
      yield LoadingFormularioSelection();
      final eitherSetChosenFormulario = await setChosenFormulario(ChooseFormularioParams(formulario: event.formulario));
      yield * eitherSetChosenFormulario.fold((_)async*{
        //TODO: Implementar manejo de errores
      }, (_)async*{
        yield OnFormularioSelected(formulario: event.formulario);
      });
    }
    
  }
}
