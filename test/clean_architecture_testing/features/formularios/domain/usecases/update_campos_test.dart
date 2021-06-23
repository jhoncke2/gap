import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/params/campos_params.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/update_campos.dart';
import 'package:mockito/mockito.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockFormulariosRepository extends Mock implements FormulariosRepository{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

UpdateCampos useCase;
MockFormulariosRepository repository;
MockUseCaseErrorHandler errorHandler;

void main(){
  Formulario tBlocFormulario;
  Formulario tStorageFormulario;
  setUp((){
    errorHandler =  MockUseCaseErrorHandler();
    repository = MockFormulariosRepository();
    useCase = UpdateCampos(
      repository: repository, 
      errorHandler: errorHandler
    );
    tBlocFormulario = _getFormulariosFromFixtures()[0];
    tStorageFormulario = _getFormulariosFromFixtures()[0]..campos = [];
  });

  test('should call the specified methods when all goes good', ()async{
    when(errorHandler.executeFunction<void>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(repository.getChosenFormulario()).thenAnswer((_) async => Right(tStorageFormulario));
    await useCase(CamposParams(campos: tBlocFormulario.campos));
    verify(errorHandler.executeFunction<void>(any));
    verify(repository.getChosenFormulario());
    verify(repository.setChosenFormulario(tBlocFormulario));
  });
  
  test('should return the specified result when all goes good', ()async{
    when(errorHandler.executeFunction<void>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(repository.getChosenFormulario()).thenAnswer((_) async => Right(tStorageFormulario));
    final result = await useCase(CamposParams(campos: tBlocFormulario.campos));
    expect(result, Right(null));
  });
}

List<Formulario> _getFormulariosFromFixtures(){
  final String stringF = callFixture('formularios.json');
  final List<Map<String, dynamic>> jsonF = jsonDecode(stringF).cast<Map<String, dynamic>>();
  return formulariosFromJson(jsonF);
}