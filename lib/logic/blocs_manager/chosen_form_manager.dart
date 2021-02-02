import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/firm_paint/firm_paint_bloc.dart';
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
    ..chosenFormBloc = BlocProvider.of<ChosenFormBloc>(appContext)
    ..firmPaintBloc = BlocProvider.of<FirmPaintBloc>(appContext);
  }

  @protected
  factory ChosenFormManagerSingleton.forTesting({
    @required BuildContext appContext,
    @required ChosenFormBloc commImgsBloc,
    @required FirmPaintBloc firmPaintBloc
  }){
    _initInitialTestingElements(appContext, commImgsBloc, firmPaintBloc);
    return _commImgsIndxManagerSingleton;
  }

  static void _initInitialTestingElements(BuildContext appContext, ChosenFormBloc chosenFormBloc, FirmPaintBloc firmPaintBloc){
    chosenFormManager
    ..appContext = appContext
    ..chosenFormBloc = chosenFormBloc
    ..firmPaintBloc = firmPaintBloc;
  }
  // ****************** Fin del modelo Singleton
}


class ChosenFormManager{
  BuildContext appContext;
  ChosenFormBloc chosenFormBloc;
  ChosenFormState chosenFormState;
  FirmPaintBloc firmPaintBloc;

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
    bool sePuedeAvanzar = _currentFirmerHasEnoughPointsInHisDraw();
    return sePuedeAvanzar;
  }
  
  bool _sePuedeAvanzarDesdeSecondaryFirmer(){
    final List<PersonalInformation> firmers = chosenFormState.firmers;
    final PersonalInformation currentFirmer = firmers.last;
    if( _firmerHasPersInfoValues(currentFirmer) && _currentFirmerHasEnoughPointsInHisDraw())
      return true;
    return false;
  }

  bool _currentFirmerHasEnoughPointsInHisDraw(){
    final FirmPaintState fpState = firmPaintBloc.state;
    final int nTotalPoints = fpState.nTotalPoints;
    return nTotalPoints > 75;
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

  void addNewFirm(){
    chosenFormBloc.add(InitFirmsFillingOut());
    firmPaintBloc.add(ResetFirmPaint());
    //TODO: ¿Servicio de crear firma en el back se implementa acá?
  }

  void finishFirms(){
    chosenFormBloc.add(ResetChosenForm());
    firmPaintBloc.add(ResetFirmPaint());
    //TODO: ¿Servicio de crear firma en el back se implementa acá?
  }
}