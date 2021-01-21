import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gap/models/entities/formulario.dart';
import 'package:gap/models/ui/form_input.dart';
import 'package:meta/meta.dart';

part 'form_inputs_navigation_event.dart';
part 'form_inputs_navigation_state.dart';

class FormInputNavigationBloc extends Bloc<FormInputNavigationEvent, FormInputNavigationState> {
  FormInputNavigationState _currentYieldedState;
  FormInputNavigationBloc() : super(FormInputNavigationState());

  @override
  Stream<FormInputNavigationState> mapEventToState(
    FormInputNavigationEvent event,
  ) async* {
    if(event is SetForm){
      _setForm(event);      
    }else if(event is ChangePageIndex){
      _changePageIndex(event);
    }else if(event is ResetAll){
      _resetAll();
    }
    yield _currentYieldedState;
  }
  
  void _setForm(SetForm event){
    final Formulario form = event.form;
    _currentYieldedState = state.copyWith(
      form: form,
      pageIndex: 0,
      showedInputs: []
    );
  }

  void _changePageIndex(ChangePageIndex event){
    final int pageIndex = event.newIndex;
    _currentYieldedState = state.copyWith(
      pageIndex: pageIndex
    );
  }

  void _resetAll(){
    _currentYieldedState = state.reset();
  }
}
