import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/get_formulario.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockMuestrasRepository extends Mock implements MuestrasRepository{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

GetFormulario useCase;
MockMuestrasRepository repository;
MockUseCaseErrorHandler errorHandler;

void main(){
  setUp((){
    errorHandler = MockUseCaseErrorHandler();
    repository = MockMuestrasRepository();
    useCase = GetFormulario(repository: repository, errorHandler: errorHandler);
  });

  group('call', (){
    Formulario tFormulario;
    setUp((){
      tFormulario = _getFormularioFromxFixture();
      when(errorHandler.executeFunction<Formulario>(any)).thenAnswer((realnvocation) => realnvocation.positionalArguments[0]());
    });

    test('should call the repository and errorHandler specified methods', ()async{
      when(repository.getFormulario(any)).thenAnswer((_) async => Right(tFormulario));
      await useCase(MuestreoFormularioParams(formularioId: tFormulario.id));
      verify(errorHandler.executeFunction<Formulario>(any));
      verify(repository.getFormulario(tFormulario.id));
    });

    test('should return Right(tFormulario) when all goes good', ()async{
      when(repository.getFormulario(any)).thenAnswer((_) async => Right(tFormulario));
      final result = await useCase(MuestreoFormularioParams(formularioId: tFormulario.id));
      expect(result, Right(tFormulario));
    });
  });
}

Formulario _getFormularioFromxFixture(){
  final String stringFs = callFixture('formularios.json');
  final List<Map<String, dynamic>> jsonFs = jsonDecode(stringFs).cast<Map<String, dynamic>>();
  return FormularioModel.fromJson(jsonFs[0]);
}