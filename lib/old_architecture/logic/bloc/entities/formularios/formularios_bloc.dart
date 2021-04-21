import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';

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
    }else if(event is ChangeFormsAreBlocked){
      _changeFormsAreBlocked(event);
    }
    yield _currentYieldedState;
  }

  void _setForms(SetForms event){
    final List<FormularioOld> forms = event.forms;
    final List<FormularioOld> pendientesForms = [];
    final List<FormularioOld> realizadosForms = [];
    forms.forEach((FormularioOld form) {
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

  void _changeFormsAreBlocked(ChangeFormsAreBlocked event){
    _currentYieldedState = state.copyWith(formsAreBlocked: event.areBlocked);
  }

  void _resetForms(){
    _currentYieldedState = state.reset();
  }

  void _chooseForm(ChooseForm event){
    final FormularioOld chosenOne = event.chosenOne;
    final List<FormularioOld> forms = state.forms;
    int chosenIndex = forms.indexWhere((element) => element.id == chosenOne.id);
    forms[chosenIndex] = chosenOne;
    _currentYieldedState = state.copyWith(
      chosenForm: chosenOne,
      forms: forms,
      formsAreBlocked: true
    );
  }
}
