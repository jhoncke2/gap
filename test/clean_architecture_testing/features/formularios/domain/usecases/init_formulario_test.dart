import 'dart:convert';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/init_formulario.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockFormulariosRepository extends Mock implements FormulariosRepository{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

InitChosenFormulario useCase;
MockFormulariosRepository repository;
MockUseCaseErrorHandler errorHandler;

void main(){
  Formulario tFormulario;
  setUp((){
    repository = MockFormulariosRepository();
    errorHandler = MockUseCaseErrorHandler();
    useCase = InitChosenFormulario(repository: repository, errorHandler: errorHandler);
    tFormulario = _getFormularioFromFixtures();
  });

  test('should call the specified methods', ()async{
    when(errorHandler.executeFunction<Formulario>(any)).thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    await useCase(NoParams());
    verify(errorHandler.executeFunction<Formulario>(any));
    verify(repository.getChosenFormulario());
  });

  test('should return the expected result', ()async{
    when(errorHandler.executeFunction<Formulario>(any)).thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(repository.getChosenFormulario()).thenAnswer((_) async => Right(tFormulario));
    final result = await useCase(NoParams());
    expect(result, Right(tFormulario));
  });
}

Formulario _getFormularioFromFixtures(){
  final String stringF = callFixture('formularios.json');
  final List<Map<String, dynamic>> jsonF = jsonDecode(stringF).cast<Map<String, dynamic>>();
  return formulariosFromJson(jsonF)[0];
}