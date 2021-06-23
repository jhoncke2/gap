import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/init_formulario.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/end_chosen_formulario.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/update_campos.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/get_formularios.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/choose_formulario.dart';
import 'package:gap/clean_architecture_structure/features/formularios/presentation/bloc/formularios_bloc.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockGetFormularios extends Mock implements GetFormularios{}
class MockSetChosenFormulario extends Mock implements ChooseFormulario{}
class MockInitChosenFormulario extends Mock implements InitChosenFormulario{}
class MockUpdateCampos extends Mock implements UpdateCampos{}
class MockEndChosenFormulario extends Mock implements EndChosenFormulario{}

FormulariosBloc bloc;
MockGetFormularios getFormularios;
MockSetChosenFormulario setChosenFormulario;
MockInitChosenFormulario initChosenFormulario;
MockUpdateCampos updateCampos;
MockEndChosenFormulario endChosenFormulario;

void main(){
  setUp((){
    endChosenFormulario = MockEndChosenFormulario();
    updateCampos = MockUpdateCampos();
    initChosenFormulario = MockInitChosenFormulario();
    setChosenFormulario = MockSetChosenFormulario();
    getFormularios = MockGetFormularios();
    bloc = FormulariosBloc(
      getFormularios: getFormularios,
      setChosenFormulario: setChosenFormulario,
      initChosenFormulario: initChosenFormulario,
      updateCampos: updateCampos,
      endChosenFormulario: endChosenFormulario
    );
  });

  group('loadFormularios', (){
    List<Formulario> tUncompletedFormularios;
    List<Formulario> tCompletedFormularios;
    setUp((){
      tUncompletedFormularios = _getUncompletedFormulariosFromFixtures();
      tCompletedFormularios = _getCompletedFormulariosFromFixtures();
    });

    test('should call the expected methods', ()async{
      when(getFormularios(any)).thenAnswer((_) async => Right(tUncompletedFormularios));
      bloc.add(LoadFormularios());
      await untilCalled(getFormularios.call(any));
      verify(getFormularios(NoParams()));
    });

    test('should yield the specified ordered states when getFormularios goes bad', ()async{
      when(getFormularios(any)).thenAnswer((_) async => Left(ServerFailure(type: ServerFailureType.NORMAL)));
      final expectedOrderedStates = [
        LoadingFormularios(),
        FormulariosLoadingError(message: FormulariosBloc.LOADING_FORMULARIOS_ERROR_MESSAGE)
      ];
      bloc.add(LoadFormularios());
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
    });

    test('''should yield the specified ordered states when all goes good 
    and Not all formularios are completed''', ()async{
      when(getFormularios(any)).thenAnswer((_) async => Right(tUncompletedFormularios));
      final expectedOrderedStates = [
        LoadingFormularios(),
        OnLoadedFormularios(formularios: tUncompletedFormularios)
      ];
      bloc.add(LoadFormularios());
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
    });

    test('''should yield the specified ordered states when all goes good 
    and all formularios are completed''', ()async{
      when(getFormularios(any)).thenAnswer((_) async => Right(tCompletedFormularios));
      final expectedOrderedStates = [
        LoadingFormularios(),
        OnCompletedFormularios()
      ];
      bloc.add(LoadFormularios());
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
    });
  });

  group('chooseFormulario', (){
    List<Formulario> tFormularios;
    Formulario tChosenFormulario;
    setUp((){
      tFormularios = _getUncompletedFormulariosFromFixtures();
      tChosenFormulario = _getUncompletedFormulariosFromFixtures()[0];
      bloc.emit(OnLoadedFormularios(formularios: tFormularios));
    });

    test('should call the specified methods', ()async{
      when(setChosenFormulario(any)).thenAnswer((_) async => Right(null));
      bloc.add(SetChosenFormularioEvent(formulario: tChosenFormulario));
      await untilCalled(setChosenFormulario(any));
      verify(setChosenFormulario(ChooseFormularioParams(formulario: tChosenFormulario)));
    });

    test('should yield the specified ordered states when all goes good', ()async{
      when(setChosenFormulario(any)).thenAnswer((_) async => Right(null));
      final expectedOrderedStates = [
        LoadingFormularioSelection(),
        OnFormularioSelected(formulario: tChosenFormulario)
      ];
      bloc.add(SetChosenFormularioEvent(formulario: tChosenFormulario));
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
    });

    test('should when gps is not finally granted', ()async{
      when(setChosenFormulario(any)).thenAnswer((_) async => Left(UngrantedGPSFailure()));
      final expectedOrderedStates = [
        LoadingFormularioSelection(),
        FormulariosLoadingError(message: FormulariosBloc.CHOOSE_FORMULARIO_UNGRANTED_GPS_ERROR_MESSAGE),
        OnLoadedFormularios(formularios: tFormularios)
      ];
      bloc.add(SetChosenFormularioEvent(formulario: tChosenFormulario));
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
    });
  });

  
  group('initChosenFormulario', (){
    Formulario tChosenFormulario;
    int tNFormFieldsPages;
    int tCurrentPage;
    bool tCanAdvance;
    bool tCanBack;
    List<CustomFormFieldOld> tFormFieldsFromPage;

    setUp((){
      tChosenFormulario = _getUncompletedFormulariosFromFixtures()[0]
          ..campos = _getFormFieldsFromFixtures();
      tNFormFieldsPages = 2;
      tCurrentPage = 0;
      tCanAdvance = false;
      tCanBack = false;
      tFormFieldsFromPage = _getFormFieldsFromFixtures().sublist(0,4);
    });

    test('should call the specified methods', ()async{
      when(initChosenFormulario(any)).thenAnswer((_) async => Right(tChosenFormulario));
      bloc.add(InitChosenFormularioEvent());
      await untilCalled(initChosenFormulario(any));
      verify(initChosenFormulario(NoParams()));
    });

    //TODO: Arreglar todo con customFormFields
    /*
    test('should yield the specified ordered states when all goes good', ()async{
      when(initChosenFormulario(any)).thenAnswer((_) async => Right(tChosenFormulario));
      final expectedOrderedStates = [
        LoadingFormularioSelection(),
        OnFormularioDetail(
          nFormFieldsPages: tNFormFieldsPages, 
          currentPage: tCurrentPage, 
          canAdvance: tCanAdvance, 
          canBack: tCanBack, 
          formFieldsFromPage: tFormFieldsFromPage, 
          formulario: tChosenFormulario
        )
      ];
      bloc.add(InitChosenFormularioEvent());
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
    });
    */
  });

  group('update campos', (){
    Formulario tChosenFormulario;
    List<CustomFormFieldOld> tFormFields;
    setUp((){
      tChosenFormulario = _getUncompletedFormulariosFromFixtures()[0];
      tFormFields = _getFormFieldsFromFixtures();
    });
  });
}

List<Formulario> _getUncompletedFormulariosFromFixtures(){
  final String stringF = callFixture('formularios.json');
  final List<Map<String, dynamic>> jsonF = jsonDecode(stringF).cast<Map<String, dynamic>>();
  return formulariosFromJson(jsonF);
}

List<Formulario> _getCompletedFormulariosFromFixtures(){
  final String stringF = callFixture('formularios_completos.json');
  final List<Map<String, dynamic>> jsonF = jsonDecode(stringF).cast<Map<String, dynamic>>();
  return formulariosFromJson(jsonF);
}

List<CustomFormFieldOld> _getFormFieldsFromFixtures(){
  final String stringFFs = callFixture('formulario_campos.json');
  final List<Map<String, dynamic>> jsonFFs = jsonDecode(stringFFs).cast<Map<String, dynamic>>();
  return customFormFieldsFromJson(jsonFFs);
}