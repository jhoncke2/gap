import 'dart:convert';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/get_formularios.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockFormulariosRepository extends Mock implements FormulariosRepository{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

GetFormularios useCase;
MockFormulariosRepository repository;
MockUseCaseErrorHandler errorHandler;

void main(){
  List<Formulario> tFormularios;
  setUp((){
    errorHandler = MockUseCaseErrorHandler();
    repository = MockFormulariosRepository();
    useCase = GetFormularios(repository: repository, errorHandler: errorHandler);
    tFormularios = _getFormulariosFromFixtures();
  });

  test('should call the expected methods', ()async{
    when(errorHandler.executeFunction<List<Formulario>>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    await useCase(NoParams());
    verify(errorHandler.executeFunction<List<Formulario>>(any));
    verify(repository.getFormularios());
  });

  test('return the expected value', ()async{
    when(repository.getFormularios()).thenAnswer((_) async => Right(tFormularios));
    when(errorHandler.executeFunction<List<Formulario>>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    final result = await useCase(NoParams());
    expect(result, Right(tFormularios));
  });
}

List<Formulario> _getFormulariosFromFixtures(){
  final String stringF = callFixture('formularios.json');
  final List<Map<String, dynamic>> jsonF = jsonDecode(stringF).cast<Map<String, dynamic>>();
  return formulariosFromJson(jsonF);
}