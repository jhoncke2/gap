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
    }else if(event is ChooseForm){
      _chooseForm(event);
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
      if(form.stage == ProcessStage.Pendiente)
        pendientesForms.add(form);
      else if(form.stage == ProcessStage.Realizada)
        realizadosForms.add(form);
    });
    _currentYieldedState = state.copyWith(
      formsAreLoaded: true, 
      forms: forms, 
      pendientesForms: pendientesForms,
      realizadosForms: realizadosForms,
      backing: false
    );
  }

  void _resetForms(){
    _currentYieldedState = state.reset();
  }

  void _chooseForm(ChooseForm event){
    final Formulario chosenOne = event.chosenOne;
    final List<Formulario> forms = state.forms;
    int chosenIndex = forms.indexWhere((element) => element.id == chosenOne.id);
    forms[chosenIndex] = chosenOne;
    _currentYieldedState = state.copyWith(
      chosenForm: chosenOne,
      forms: forms
    );
  }
}
