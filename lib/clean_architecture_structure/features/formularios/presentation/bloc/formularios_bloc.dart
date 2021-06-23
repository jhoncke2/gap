import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/form_field/variable/variable_form_field.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/end_chosen_formulario.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/get_formularios.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/choose_formulario.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/init_formulario.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/update_campos.dart';
import 'package:gap/old_architecture/data/models/entities/custom_form_field/variable/variable_form_field.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
part 'formularios_event.dart';
part 'formularios_state.dart';

class FormulariosBloc extends Bloc<FormulariosEvent, FormulariosState> {
  static const LOADING_FORMULARIOS_ERROR_MESSAGE = 'Ocurrió un error cargando los formularios';
  static const CHOOSE_FORMULARIO_UNGRANTED_GPS_ERROR_MESSAGE = 'Debes activar el permiso de ubicación(gps) para poder iniciar el formulario';
  static const ITEMS_PER_FORMFIELDS_PAGE = 4;

  final GetFormularios getFormularios;
  final ChooseFormulario setChosenFormulario;
  final InitChosenFormulario initChosenFormulario;
  final UpdateCampos updateCampos;
  final EndChosenFormulario endChosenFormulario;

  FormulariosBloc({
    @required this.getFormularios,
    @required this.setChosenFormulario,
    @required this.initChosenFormulario,
    @required this.updateCampos,
    @required this.endChosenFormulario 
  }) : super(FormulariosEmpty());

  @override
  Stream<FormulariosState> mapEventToState(
    FormulariosEvent event,
  ) async* {
    if(event is LoadFormularios){
      yield * _loadFormularios();
    }else if(event is SetChosenFormularioEvent){
      yield * _setChosenFormularioEvent(event);
    }else if(event is InitChosenFormularioEvent){
      yield * _initChosenFormularioEvent();
    }
  }

  Stream<FormulariosState> _loadFormularios()async*{
    yield LoadingFormularios();
    final eitherFormularios = await getFormularios(NoParams());
    yield * eitherFormularios.fold((_)async*{
      yield FormulariosLoadingError(message: LOADING_FORMULARIOS_ERROR_MESSAGE);
    }, (formularios)async*{
      if(_allFormulariosAreCompleted(formularios))
        yield OnCompletedFormularios();
      else
        yield OnLoadedFormularios(formularios: formularios);
    });
  }

  bool _allFormulariosAreCompleted(List<Formulario> formularios){
    for(Formulario f in formularios)
      if(!f.completo)
        return false;
    return true;
  }

  Stream<FormulariosState> _setChosenFormularioEvent(SetChosenFormularioEvent event)async*{
    final List<Formulario> formularios = (state as OnLoadedFormularios).formularios;
    yield LoadingFormularioSelection();
    final eitherSetChosenFormulario = await setChosenFormulario(ChooseFormularioParams(formulario: event.formulario));
    yield * eitherSetChosenFormulario.fold((failure)async*{
      if(failure is UngrantedGPSFailure)
        yield FormulariosLoadingError(message: CHOOSE_FORMULARIO_UNGRANTED_GPS_ERROR_MESSAGE);
      yield await Future.delayed(Duration(milliseconds: 1500), ()async{
        return OnLoadedFormularios(formularios: formularios);
      });
    }, (_)async*{
      yield OnFormularioSelected(formulario: event.formulario);
    });
  }

  Stream<FormulariosState> _initChosenFormularioEvent()async*{
    yield LoadingFormularioSelection();
    final eitherInitChosenFormulario = await initChosenFormulario(NoParams());
    yield * eitherInitChosenFormulario.fold((l)async*{
      //TODO: Implementar manejo de errores
    }, (formulario)async*{
      yield * _initChosenFormCampos(formulario);
    });
  }

  Stream<FormulariosState> _initChosenFormCampos(Formulario formulario)async*{
    List<CustomFormFieldOld> allFormFields = formulario.campos;
    int initialPage = 0;
    int nPages = (allFormFields.length/ITEMS_PER_FORMFIELDS_PAGE).ceil();
    int remainderItemsForLastPage = allFormFields.length % ITEMS_PER_FORMFIELDS_PAGE;
    List<CustomFormFieldOld> formFieldsFromPage;
    if(_isLastPageAndThereIsFinalRemainder(initialPage, nPages, remainderItemsForLastPage))
      formFieldsFromPage = _generatePageWithNItems(allFormFields, initialPage, remainderItemsForLastPage);
    else
      formFieldsFromPage = _generatePageWithNItems(allFormFields, initialPage, ITEMS_PER_FORMFIELDS_PAGE);
    yield OnFormularioDetail(
      nFormFieldsPages: nPages, 
      currentPage: initialPage, 
      canAdvance: _currentPageCanAdvance(formFieldsFromPage), 
      canBack: _currentPageCanBack(initialPage), 
      formFieldsFromPage: formFieldsFromPage, 
      formulario: formulario
    );
  }

  bool _isLastPageAndThereIsFinalRemainder(int page, int nPages, int remainderItemsForLastPage){
    return (page == nPages - 1  && remainderItemsForLastPage > 0);
  }

  List<CustomFormFieldOld> _generatePageWithNItems(List<CustomFormFieldOld> allFormFields, int page, int nItems){
    final List<CustomFormFieldOld> formFieldsFromPage = [];
    for(int i = 0; i < nItems; i++)
      formFieldsFromPage.add(allFormFields[page*ITEMS_PER_FORMFIELDS_PAGE + i]);
    return formFieldsFromPage;
  }

  bool _currentPageCanAdvance(List<CustomFormFieldOld> formFields){
    for(CustomFormFieldOld ff in formFields)
      if(ff is VariableFormFieldOld && ff.isRequired && !ff.isCompleted)
        return false;
    return true;
  }

  bool _currentPageCanBack(int page){
    return page > 0;
  }
}