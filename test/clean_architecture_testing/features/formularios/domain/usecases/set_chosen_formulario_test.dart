import 'dart:convert';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/set_chosen_formulario.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockFormulariosRepository extends Mock implements FormulariosRepository{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

SetChosenFormulario useCase;
MockFormulariosRepository repository;
MockUseCaseErrorHandler errorHandler;

void main(){
  Formulario tFormulario;
  setUp((){
    errorHandler = MockUseCaseErrorHandler();
    repository = MockFormulariosRepository();
    useCase = SetChosenFormulario(repository: repository, errorHandler: errorHandler);
    tFormulario = _getFormularioFromFixtures();
  });

  test('should call the specified methods', ()async{
    when(errorHandler.executeFunction<void>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    await useCase(ChooseFormularioParams(formulario: tFormulario));
    verify(repository.setChosenFormulario(tFormulario));
    verify(errorHandler.executeFunction<void>(any));
  });

  test('should call the specified methods', ()async{
    when(errorHandler.executeFunction<void>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(repository.setChosenFormulario(any)).thenAnswer((_) async => Right(null));
    final result = await useCase(ChooseFormularioParams(formulario: tFormulario));
    expect(result, Right(null));
  });
}

Formulario _getFormularioFromFixtures(){
  final String stringF = callFixture('formularios.json');
  final List<Map<String, dynamic>> jsonF = jsonDecode(stringF).cast<Map<String, dynamic>>();
  return formulariosFromJson(jsonF)[0];
}