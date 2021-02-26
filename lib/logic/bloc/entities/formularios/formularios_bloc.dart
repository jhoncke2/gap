import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/data/enums/enums.dart';

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
    }else if(event is ChooseForm){
      _chooseForm(event);
    }
    yield _currentYieldedState;
  }

  void _setForms(SetForms event){
    final List<OldFormulario> forms = event.forms;
    final List<OldFormulario> pendientesForms = [];
    final List<OldFormulario> realizadosForms = [];
    forms.forEach((OldFormulario form) {
      if(form.stage == ProcessStage.Pendiente)
        pendientesForms.add(form);
      else if(form.stage == ProcessStage.Realizada)
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

  void _chooseForm(ChooseForm event){
    final OldFormulario chosenOne = event.chosenOne;
    _currentYieldedState = state.copyWith(
      chosenForm: chosenOne
    );
  }
}
