import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/models/entities/personal_information.dart';
class ChosenFormManagerSingleton{
  static final ChosenFormManagerSingleton _commImgsIndxManagerSingleton = ChosenFormManagerSingleton._internal();
  static final ChosenFormManager chosenFormManager = ChosenFormManager();
  ChosenFormManagerSingleton._internal();

  factory ChosenFormManagerSingleton({
    @required BuildContext appContext
  }){
    _initInitialElements(appContext);
    return _commImgsIndxManagerSingleton;
  }
  
  static void _initInitialElements(BuildContext appContext){
    chosenFormManager..appContext = appContext
    ..chosenFormBloc = BlocProvider.of<ChosenFormBloc>(appContext);
    chosenFormManager.chosenFormState = chosenFormManager.chosenFormBloc.state;    
  }

  @protected
  factory ChosenFormManagerSingleton.forTesting({
    @required BuildContext appContext,
    @required ChosenFormBloc commImgsBloc, 
  }){
    _initInitialTestingElements(appContext, commImgsBloc);
    return _commImgsIndxManagerSingleton;
  }

  static void _initInitialTestingElements(BuildContext appContext, ChosenFormBloc chosenFormBloc){
    chosenFormManager
    ..appContext = appContext
    ..chosenFormBloc = chosenFormBloc
    ..chosenFormState = chosenFormBloc.state;
  }
  // ****************** Fin del modelo Singleton
}


class ChosenFormManager{
  BuildContext appContext;
  ChosenFormBloc chosenFormBloc;
  ChosenFormState chosenFormState;

  bool canGoToNextFormStep(){
    _updateState();
    switch(chosenFormState.formStep){
      case FormStep.WithoutForm:
        return true;
      case FormStep.OnForm:
        // TODO: Implementar recorrido de formularios cuando se hayan implementado estos.
        return true;
      case FormStep.OnFirstFirmerInformation:
        return _sePuedeAvanzarDesdeFirstFirmerInfo();
      case FormStep.OnFirstFirmerFirm:
        return _sePuedeAvanzarDesdeFirstFirmerFirm();
      case FormStep.OnSecondaryFirms:
        return _sePuedeAvanzarDesdeSecondaryFirmer();
      default:
        return true;
    }
  }

  void _updateState(){
    chosenFormState = chosenFormBloc.state;
  }

  bool _sePuedeAvanzarDesdeFirstFirmerInfo(){
    final PersonalInformation firstFirmer = chosenFormState.firmers[0];
    final bool sePuedeAvanzar = _firmerHasPersInfoValues(firstFirmer);
    return sePuedeAvanzar;
  }

  bool _sePuedeAvanzarDesdeFirstFirmerFirm(){
    bool sePuedeAvanzar = false;
    final File firm = chosenFormState.firmers[0].firm;
    if(firm != null)
      sePuedeAvanzar = true;
    return sePuedeAvanzar;
  }
  
  bool _sePuedeAvanzarDesdeSecondaryFirmer(){
    final List<PersonalInformation> firmers = chosenFormState.firmers;
    final PersonalInformation currentFirmer = firmers.last;
    final bool sePuedeAvanzar = _firmerHasPersInfoValues(currentFirmer);
    return sePuedeAvanzar;
  }

  bool _firmerHasPersInfoValues(PersonalInformation firmer){
    final String name = firmer.name;
    final String identifDocType = firmer.identifDocumentType;
    final int identifDocNumber = firmer.identifDocumentNumber;
    final List invalidValues = [null, ''];
    if(!invalidValues.contains(name) && !invalidValues.contains(identifDocType) && !invalidValues.contains(identifDocNumber)){
      return true;
    }
    return false;
  }
}