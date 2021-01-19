import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gap/enums/process_stage.dart';
import 'package:gap/models/formulario.dart';
import 'package:meta/meta.dart';

part 'formularios_event.dart';
part 'formularios_state.dart';

class FormulariosBloc extends Bloc<FormulariosEvent, FormulariosState> {
  FormulariosState _currentYieldedState;
  FormulariosBloc() : super(FormulariosState());

  @override
  Stream<FormulariosState> mapEventToState(
    FormulariosEvent event,
  ) async* {
    if(event is SetForms){
      _setForms(event);
    }else if(event is ResetForms){
      _resetForms();
    }
    yield _currentYieldedState;
  }

  void _setForms(SetForms event){
    final List<Formulario> forms = event.forms;
    final List<Formulario> pendientesForms = [];
    final List<Formulario> realizadosForms = [];
    forms.forEach((Formulario form) {
      if(form.currentStage == ProcessStage.Pendiente)
        pendientesForms.add(form);
      else if(form.currentStage == ProcessStage.Realizada)
        realizadosForms.add(form);
    });
    _currentYieldedState = state.copyWith(
      formsAreLoaded: true, 
      forms: forms, 
      pendientesForms: pendientesForms,
      realizadosForms: realizadosForms
    );
  }

  void _resetForms(){
    _currentYieldedState = state.reset();
  }
}
