import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gap/logic/models/entities/form_field.dart';
import 'package:gap/logic/models/entities/formulario.dart';
import 'package:gap/logic/models/entities/personal_information.dart';
import 'package:meta/meta.dart';

part 'chosen_form_event.dart';
part 'chosen_form_state.dart';

class ChosenFormBloc extends Bloc<ChosenFormEvent, ChosenFormState> {
  ChosenFormState _currentStateToYield;
  ChosenFormBloc() : super(ChosenFormState());

  @override
  Stream<ChosenFormState> mapEventToState(
    ChosenFormEvent event,
  ) async* {
    if(event is InitFormFillingOut){
      _initFormFillingOut(event);
    }else if(event is InitFirstFirmerFillingOut){
      _initFirstFirmerFillingOut(event);
    }else if(event is InitFirstFirmerFirm){
      _initFirstFirmerFirm(event);
    }else if(event is InitFirmsFillingOut){
      _initFirmsFillingOut(event);
    }else if(event is AddFirmerPersonalInformation){
      _addFirmerPersonalInformation(event);
    }else if(event is ResetChosenForm){
      _resetChosenForm();
    }
    yield _currentStateToYield;
  }

  void _initFormFillingOut(InitFormFillingOut event){
    final Formulario formulario = event.formulario;
    //TODO: Implementar la creación de los formfields
    _currentStateToYield = state.copyWith(
      formStep: FormStep.OnForm
    );    
  }

  void _initFirstFirmerFillingOut(InitFirstFirmerFillingOut event){
    _currentStateToYield = state.copyWith(
      formStep: FormStep.OnFirstFirmerInformation
    );
  }

  void _initFirstFirmerFirm(InitFirstFirmerFirm event){
    _currentStateToYield = state.copyWith(
      formStep: FormStep.OnFirstFirmerFirm
    );
  }

  void _initFirmsFillingOut(InitFirmsFillingOut event){
    _currentStateToYield = state.copyWith(
      formStep: FormStep.OnFirms
    );
  }

  void _addFirmerPersonalInformation(AddFirmerPersonalInformation event){
    _currentStateToYield = state.copyWith();
  }

  void _resetChosenForm(){
    _currentStateToYield = ChosenFormState();
  }
}
