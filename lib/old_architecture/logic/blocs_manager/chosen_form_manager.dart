import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/static/static_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/variable_form_field.dart';
import 'package:gap/old_architecture/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/firm_paint/firm_paint_bloc.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/old_architecture/logic/helpers/painter_to_image_converter.dart';
import 'package:gap/old_architecture/ui/pages/formulario_detail/forms/form_body/center_containers/firm_fields/firm_draw_field/firm_paint.dart';

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
    ..firmPaintBloc = BlocProvider.of<FirmPaintBloc>(appContext)
    ..formsBloc = BlocProvider.of<FormulariosOldBloc>(appContext)
    ..indexBloc = BlocProvider.of<IndexOldBloc>(appContext)
      ;
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
}


class ChosenFormManager{
  BuildContext appContext;
  ChosenFormBloc chosenFormBloc;
  ChosenFormState chosenFormState;
  FirmPaintBloc firmPaintBloc;
  FormulariosOldBloc formsBloc;
  FormulariosState formsState;
  IndexOldBloc indexBloc;

  void updateIndexByFormFieldsChange(){
    _updateStates();
    final int currentIndexPage = indexBloc.state.currentIndexPage;
    final List<CustomFormFieldOld> pageFormFields = chosenFormState.getFormFieldsByIndex(currentIndexPage);
    final bool allFormFieldsFromPageAreCompleted = _thoseFormFieldsAreCompleted(pageFormFields);
    _updateIndexIfPageFormFieldsAreCompleted(allFormFieldsFromPageAreCompleted, currentIndexPage);
  }

  bool _thoseFormFieldsAreCompleted(List<CustomFormFieldOld> formFields){
    for(CustomFormFieldOld cff in formFields)
      if(!_formFieldIsCompleted(cff))
        return false;
    return true;
  }

  static bool _formFieldIsCompleted(CustomFormFieldOld cff){
    return !(cff is VariableFormFieldOld && ((cff.isRequired && cff.isCompleted) || !cff.isRequired)) || cff is StaticFormFieldOld;
  }

  void _updateIndexIfPageFormFieldsAreCompleted(bool pageFormFieldsAreCompleted, int currentIndexPage){
    if(pageFormFieldsAreCompleted)
      _updateIndexIfCurrentIndexIsNotLast(currentIndexPage);
  }

  void _updateIndexIfCurrentIndexIsNotLast(int currentIndexPage){
    if(currentIndexPage < indexBloc.state.nPages -1)
      _updateIndex();
  }

  void _updateIndex(){
    indexBloc.add(ChangeSePuedeAvanzar(sePuede: true));
  }

  bool canGoToNextFormStep(){
    _updateStates();
    switch(chosenFormState.formStep){
      case FormStep.WithoutForm:
        return true;
      case FormStep.OnFormFillingOut:
        return _sePuedeAvanzarDesdeOnFormFillingOut();
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

  bool _sePuedeAvanzarDesdeOnFormFillingOut(){
    //return formsState.chosenForm.allFieldsAreCompleted();
    return true;
  }

  bool _sePuedeAvanzarDesdeFirstFirmerInfo(){
    final PersonalInformationOld firstFirmer = chosenFormState.firmers[0];
    final bool sePuedeAvanzar = _firmerHasPersInfoValues(firstFirmer);
    return sePuedeAvanzar;
  }

  bool _sePuedeAvanzarDesdeFirstFirmerFirm(){
    bool sePuedeAvanzar = _currentFirmerHasEnoughPointsInHisDraw();
    return sePuedeAvanzar;
  }
  
  bool _sePuedeAvanzarDesdeSecondaryFirmer(){
    final List<PersonalInformationOld> firmers = chosenFormState.firmers;
    final PersonalInformationOld currentFirmer = firmers.last;
    if( _firmerHasPersInfoValues(currentFirmer) && _currentFirmerHasEnoughPointsInHisDraw())
      return true;
    return false;
  }

  bool _currentFirmerHasEnoughPointsInHisDraw(){
    final FirmPaintState fpState = firmPaintBloc.state;
    final int nTotalPoints = fpState.nTotalPoints;
    return nTotalPoints > 5;
  }

  bool _firmerHasPersInfoValues(PersonalInformationOld firmer){
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
  }

  void finishFirms(){
    chosenFormBloc.add(ResetChosenForm());
    firmPaintBloc.add(ResetFirmPaint());
  }

  Future<void> addFirmToFirmer()async{
    _updateStates();
    final int lastFirmerIndex = chosenFormState.firmers.length - 1;
    final FirmPainter firmPainter = firmPaintBloc.state.firmPainter;
    final File firmFile = await PainterToImageConverter.createFileFromFirmPainter(firmPainter, lastFirmerIndex);
    final PersonalInformationOld currentFirmer = chosenFormState.firmers[lastFirmerIndex];
    currentFirmer.firm = firmFile;
    final UpdateFirmerPersonalInformation ufpiEvent = UpdateFirmerPersonalInformation(firmer: currentFirmer);
    chosenFormBloc.add(ufpiEvent);
  }

  void _updateStates(){
    chosenFormState = chosenFormBloc.state;
    formsState = formsBloc.state;
  }
}