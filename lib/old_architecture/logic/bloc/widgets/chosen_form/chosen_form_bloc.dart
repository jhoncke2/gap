import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/variable_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
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
    if(event is ChangeFormIsLocked){
      _changeFormIsLocked(event);
    }if(event is InitFormFillingOut){
      _initFormFillingOut(event);
    }else if(event is UpdateFormField){
      _updateFormField(event);
    }else if (event is InitFormReading){
      _initFormReading(event);
    }else if(event is InitFirstFirmerFillingOut){
      _initFirstFirmerFillingOut(event);
    }else if(event is InitFirstFirmerFirm){
      _initFirstFirmerFirm(event);
    }else if(event is InitFirmsFillingOut){
      _initFirmsFillingOut(event);
    }else if(event is UpdateFirmerPersonalInformation){
      _updateFirmerPersonalInformation(event);
    }else if(event is InitFirmsFinishing){
      _initFirmsFinishing();
    }else if(event is InitFormFinishing){
      _initFormFinishing(event);
    }else if(event is ResetChosenForm){
      _resetChosenForm();
    }
    yield _currentStateToYield;
  }

  void _changeFormIsLocked(ChangeFormIsLocked event){
    _currentStateToYield = state.copyWith(formIsLocked: event.isLocked);
  }

  void _initFormFillingOut(InitFormFillingOut event){
    final FormularioOld formulario = event.formulario;
    final List<List<CustomFormFieldOld>> formFieldsPerPages = _createFormsFieldsByPage(formulario);
    _currentStateToYield = state.copyWith(
      formStep: FormStep.OnFormFillingOut,
      firmers: formulario.firmers,
      formFieldsPerPage: formFieldsPerPages
    ); 
    event.onEndEvent(formFieldsPerPages.length);
  }

  List<List<CustomFormFieldOld>> _createFormsFieldsByPage(FormularioOld formulario){
     _formFieldsByPageGenerator.formFields = formulario.campos;
     return _formFieldsByPageGenerator.createFormFieldsPerPage();
  }

  void _updateFormField(UpdateFormField event){
    _currentStateToYield = state.copyWith();
    final List<CustomFormFieldOld> formFieldsByPage = state.getFormFieldsByIndex(event.pageOfFormField);
    final bool formFieldsByPageAreFilled = _formFieldsAreFilled(formFieldsByPage);
    event.onEndFunction(formFieldsByPageAreFilled);
  }

  bool _formFieldsAreFilled(List<CustomFormFieldOld> formFields){
    bool allAreCompleted = true;
    for(CustomFormFieldOld ff in formFields){
      if(_isVariableAndRequired(ff))
        if(!_variableRequiredFormFieldIsCompleted(ff))
          return false;
    }
    return allAreCompleted;
  }

  bool _isVariableAndRequired(CustomFormFieldOld ff){
    return ff is VariableFormFieldOld && ff.isRequired;
  }

  bool _variableRequiredFormFieldIsCompleted(VariableFormFieldOld vff){
    return vff.isCompleted;
  }

  void _initFormReading(InitFormReading event){
    final FormularioOld formulario = event.formulario;
    final List<List<CustomFormFieldOld>> formFieldsPerPages = _createFormsFieldsByPage(formulario);
    _currentStateToYield = state.copyWith(
      formStep: FormStep.OnFormReading,
      formFieldsPerPage: formFieldsPerPages
    );
    if(event.onEndEvent != null)
      event.onEndEvent(formFieldsPerPages.length);
  }

  void _initFirstFirmerFillingOut(InitFirstFirmerFillingOut event){
    final PersonalInformationOld firstFirmer = PersonalInformationOld();
    final List<PersonalInformationOld> firmers = [firstFirmer];
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
    final PersonalInformationOld newFirmer = PersonalInformationOld();
    final List<PersonalInformationOld> firmers = state.firmers??[];
    if(firmers.isEmpty)
      firmers.add(newFirmer);
    else
      _resetCurrentFirmer(firmers.last);
    
    //firmers.add(newFirmer);
    _currentStateToYield = state.copyWith(
      formStep: FormStep.OnSecondaryFirms,
      firmers: firmers
    );
  }

  void _initFirmsFinishing(){
    _currentStateToYield = state.copyWith(
      formStep: FormStep.Finished
    );
  }

  void _initFormFinishing(InitFormFinishing event){
    final FormularioOld form = event.form;
    final List<List<CustomFormFieldOld>> formFieldsPerPage = _createFormsFieldsByPage(form);
    _currentStateToYield = state.copyWith(
      formStep: FormStep.Finished,
      formFieldsPerPage: formFieldsPerPage
    );
    event.onEnd(formFieldsPerPage.length);
  }

  void _resetCurrentFirmer(PersonalInformationOld firmer){
    firmer.firm = null;
    firmer.identifDocumentNumber = null;
    firmer.name = null;
    firmer.identifDocumentType = null;
    firmer.cargo = null;
  }

  void _updateFirmerPersonalInformation(UpdateFirmerPersonalInformation event){
    final PersonalInformationOld firmer = event.firmer;
    final List<PersonalInformationOld> firmers = state.firmers;
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



class FormFieldsByPageGenerator{
  List<CustomFormFieldOld> _items;
  //TODO: Reemplazar por mejor algoritmo
  final int _itemsPerPage = 4;
  int _nPages;
  int _remainderItemsForLastPage;

  set formFields(List<CustomFormFieldOld> newFormFields){
    _items = newFormFields;
    _nPages = (_items.length/_itemsPerPage).ceil();
    _remainderItemsForLastPage = _items.length % _itemsPerPage;
  }

  List<List<CustomFormFieldOld>> createFormFieldsPerPage(){
    //TODO: Implementar un algoritmo mejor
    final List<List<CustomFormFieldOld>> formFieldsByPages = [];
    for(int i = 0; i < _nPages; i++){
      formFieldsByPages.add( _generateItemsForPage(i) );
    }
    return formFieldsByPages;
  }
  
  List<CustomFormFieldOld> _generateItemsForPage(int page){
    if(_isLastPageAndThereIsFinalRemainder(page))
      return _generatePageWithNItems(page, _remainderItemsForLastPage);
    else
      return _generatePageWithNItems(page, _itemsPerPage);
  }

  bool _isLastPageAndThereIsFinalRemainder(int page){
    return (page == _nPages - 1  && _remainderItemsForLastPage > 0);
  }

  List<CustomFormFieldOld> _generatePageWithNItems(int page, int nItems){
    final List<CustomFormFieldOld> items = [];
    for(int i = 0; i < nItems; i++)
      items.add(_items[page*_itemsPerPage + i]);
    return items;
  }
}