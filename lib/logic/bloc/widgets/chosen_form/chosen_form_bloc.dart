import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gap/data/models/entities/entities.dart';
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
    }else if(event is UpdateFirmerPersonalInformation){
      _updateFirmerPersonalInformation(event);
    }else if(event is ResetChosenForm){
      _resetChosenForm();
    }
    yield _currentStateToYield;
  }

  void _initFormFillingOut(InitFormFillingOut event){
    final OldFormulario formulario = event.formulario;
    //TODO: Implementar la creación de los formfields
    _currentStateToYield = state.copyWith(
      formStep: FormStep.OnForm,
      firmers: formulario.firmers,
      
    ); 
  }

  void _initFirstFirmerFillingOut(InitFirstFirmerFillingOut event){
    final PersonalInformation firstFirmer = PersonalInformation();
    final List<PersonalInformation> firmers = [firstFirmer];
    _currentStateToYield = state.copyWith(
      formStep: FormStep.OnFirstFirmerInformation,
      firmers: firmers
    );
  }

  void _initFirstFirmerFirm(InitFirstFirmerFirm event){
    _currentStateToYield = state.copyWith(
      formStep: FormStep.OnFirstFirmerFirm
    );
  }

  void _initFirmsFillingOut(InitFirmsFillingOut event){
    final PersonalInformation newFirmer = PersonalInformation();
    final List<PersonalInformation> firmers = state.firmers;
    firmers.add(newFirmer);
    _currentStateToYield = state.copyWith(
      formStep: FormStep.OnSecondaryFirms,
      firmers: firmers
    );
  }

  void _updateFirmerPersonalInformation(UpdateFirmerPersonalInformation event){
    final PersonalInformation firmer = event.firmer;
    final List<PersonalInformation> firmers = state.firmers;
    firmers[firmers.length - 1] = firmer;
    _currentStateToYield = state.copyWith(
      firmers: firmers
    );
  }

  void _resetChosenForm(){
    _currentStateToYield = ChosenFormState();
    //ChosenFormStorageManager.removeChosenForm();
  }
}
