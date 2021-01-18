import 'dart:async';

import 'package:bloc/bloc.dart';
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
    _currentYieldedState = state.copyWith(
      formsAreLoaded: true,
      forms: forms
    );
  }

  void _resetForms(){
    _currentYieldedState = state.reset();
  }
}
