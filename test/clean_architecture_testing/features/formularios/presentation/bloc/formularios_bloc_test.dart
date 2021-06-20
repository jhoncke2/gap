import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/get_formularios.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/set_chosen_formulario.dart';
import 'package:gap/clean_architecture_structure/features/formularios/presentation/bloc/formularios_bloc.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockGetFormularios extends Mock implements GetFormularios{}
class MockSetChosenFormulario extends Mock implements SetChosenFormulario{}

FormulariosBloc bloc;
MockGetFormularios getFormularios;
MockSetChosenFormulario setChosenFormulario;

void main(){
  setUp((){
    setChosenFormulario = MockSetChosenFormulario();
    getFormularios = MockGetFormularios();
    bloc = FormulariosBloc(
      getFormularios: getFormularios, 
      setChosenFormulario: setChosenFormulario
    );
  });

  group('getFormularios', (){
    List<Formulario> tFormularios;
    setUp((){
      tFormularios = _getFormulariosFromFixtures();
    });

    test('should call the expected methods', ()async{
      when(getFormularios(any)).thenAnswer((_) async => Right(tFormularios));
      bloc.add(LoadFormularios());
      await untilCalled(getFormularios.call(any));
      verify(getFormularios(NoParams()));
    });

    test('should yield the specified ordered states', ()async{
      when(getFormularios(any)).thenAnswer((_) async => Left(ServerFailure(type: ServerFailureType.NORMAL)));
      final expectedOrderedStates = [
        LoadingFormularios(),
        LoadingFormulariosError(message: FormulariosBloc.LOADING_FORMULARIOS_ERROR_MESSAGE)
      ];
      bloc.add(LoadFormularios());
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
    });

    test('should yield the specified ordered states', ()async{
      when(getFormularios(any)).thenAnswer((_) async => Right(tFormularios));
      final expectedOrderedStates = [
        LoadingFormularios(),
        OnLoadedFormularios(formularios: tFormularios)
      ];
      bloc.add(LoadFormularios());
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
    });
  });

  group('chooseChosenFormulario', (){
    List<Formulario> tFormularios;
    Formulario tChosenFormulario;
    setUp((){
      tFormularios = _getFormulariosFromFixtures();
      tChosenFormulario = _getFormulariosFromFixtures()[0];
      bloc.emit(OnLoadedFormularios(formularios: tFormularios));
    });

    test('should call the specified methods', ()async{
      when(setChosenFormulario(any)).thenAnswer((_) async => Right(null));
      bloc.add(SetChosenFormularioEvent(formulario: tChosenFormulario));
      await untilCalled(setChosenFormulario(any));
      verify(setChosenFormulario(ChooseFormularioParams(formulario: tChosenFormulario)));
    });

    test('should yield the specified ordered states', ()async{
      when(setChosenFormulario(any)).thenAnswer((_) async => Right(null));
      final expectedOrderedStates = [
        LoadingFormularioSelection(),
        OnFormularioSelected(formulario: tChosenFormulario)
      ];
      bloc.add(SetChosenFormularioEvent(formulario: tChosenFormulario));
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
    });
  });
}

List<Formulario> _getFormulariosFromFixtures(){
  final String stringF = callFixture('formularios.json');
  final List<Map<String, dynamic>> jsonF = jsonDecode(stringF).cast<Map<String, dynamic>>();
  return formulariosFromJson(jsonF);
}