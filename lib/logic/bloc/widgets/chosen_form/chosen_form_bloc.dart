import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gap/data/models/entities/custom_form_field/static/static_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/multi_value/multi_value_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/single_value/single_value_form_field.dart';
import 'package:gap/data/models/entities/custom_form_field/variable/variable_form_field.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:meta/meta.dart';

part 'chosen_form_event.dart';
part 'chosen_form_state.dart';

class ChosenFormBloc extends Bloc<ChosenFormEvent, ChosenFormState> {
  
  final FormFieldsByPageGenerator _formFieldsByPageGenerator = FormFieldsByPageGenerator();

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
    }else if(event is UpdateFormField){
      _updateFormField(event);
    }else if(event is ResetChosenForm){
      _resetChosenForm();
    }
    yield _currentStateToYield;
  }

  void _initFormFillingOut(InitFormFillingOut event){
    final Formulario formulario = event.formulario;
     _formFieldsByPageGenerator.formFields = formulario.campos;
    final List<List<CustomFormField>> formFieldsPerPages = _formFieldsByPageGenerator.createFormFieldsPerPage();
    //TODO: Implementar la creación de los formfields
    _currentStateToYield = state.copyWith(
      formStep: FormStep.OnForm,
      firmers: formulario.firmers,
      formFieldsPerPage: formFieldsPerPages
    ); 
    event.onEndEvent(formFieldsPerPages.length);
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
    final List<PersonalInformation> firmers = state.firmers??[];
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

  void _updateFormField(UpdateFormField event){
    _currentStateToYield = state.copyWith();
    final List<CustomFormField> formFieldsByPage = state.getFormFieldsByIndex(event.pageOfFormField);
    final bool formFieldsByPageAreFilled = _formFieldsAreFilled(formFieldsByPage);
    event.onEndFunction(formFieldsByPageAreFilled);
  }

  bool _formFieldsAreFilled(List<CustomFormField> formFields){
    bool allAreCompleted = true;
    for(CustomFormField ff in formFields){
      if(_isVariableAndRequired(ff))
        if(!_variableRequiredFormFieldIsCompleted(ff))
          return false;
    }
    return allAreCompleted;
  }

  bool _isVariableAndRequired(CustomFormField ff){
    return ff is VariableFormField && ff.isRequired;
  }

  bool _variableRequiredFormFieldIsCompleted(VariableFormField vff){
    return vff.isCompleted;
  }
  
  void _resetChosenForm(){
    _currentStateToYield = ChosenFormState();
    //ChosenFormStorageManager.removeChosenForm();
  }
}

class FormFieldsByPageGenerator{
  List<CustomFormField> _items;
  //TODO: Reemplazar por mejor algoritmo
  final int _itemsPerPage = 4;
  int _nPages;
  int _remainderItemsForLastPage;

  set formFields(List<CustomFormField> newFormFields){
    _items = newFormFields;
    _nPages = (_items.length/_itemsPerPage).ceil();
    _remainderItemsForLastPage = _items.length % _itemsPerPage;
  }

  List<List<CustomFormField>> createFormFieldsPerPage(){
    //TODO: Implementar un algoritmo mejor
    final List<List<CustomFormField>> formFieldsByPages = [];
    for(int i = 0; i < _nPages; i++){
      formFieldsByPages.add( _generateItemsForPage(i) );
    }
    return formFieldsByPages;
  }
  
  List<CustomFormField> _generateItemsForPage(int page){
    if(_isLastPageAndThereIsFinalRemainder(page))
      return _generatePageWithNItems(page, _remainderItemsForLastPage);
    else
      return _generatePageWithNItems(page, _itemsPerPage);
  }

  bool _isLastPageAndThereIsFinalRemainder(int page){
    return (page == _nPages - 1  && _remainderItemsForLastPage > 0);
  }

  List<CustomFormField> _generatePageWithNItems(int page, int nItems){
    final List<CustomFormField> items = [];
    for(int i = 0; i < nItems; i++)
      items.add(_items[page*_itemsPerPage + i]);
    return items;
  }
}