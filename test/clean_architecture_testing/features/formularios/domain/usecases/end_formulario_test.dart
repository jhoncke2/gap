import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/custom_position.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/usecase_permissions_manager.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/platform/locator.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/end_chosen_formulario.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/params/campos_params.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockFormulariosRepository extends Mock implements FormulariosRepository{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}
class MockUseCasePermissionsManager extends Mock implements UseCasePermissionsManager{}
class MockCustomLocator extends Mock implements CustomLocator{}

EndChosenFormulario useCase;
MockFormulariosRepository repository;
MockUseCaseErrorHandler errorHandler;
MockUseCasePermissionsManager permissions;
MockCustomLocator locator;

void main(){
  CustomPosition tPosition;
  Formulario tBlocFormulario;
  Formulario tStorageFormulario;
  setUp((){
    locator = MockCustomLocator();
    permissions = MockUseCasePermissionsManager();
    errorHandler =  MockUseCaseErrorHandler();
    repository = MockFormulariosRepository();
    useCase = EndChosenFormulario(
      repository: repository, 
      errorHandler: errorHandler, 
      permissions: permissions, 
      locator: locator
    );
    tPosition = CustomPosition(latitude: 1.0, longitude: 2.5);
    tBlocFormulario = _getFormulariosFromFixtures()[0];
    tStorageFormulario = _getFormulariosFromFixtures()[0]..campos = [];
  });
  
  test('should call the specified methods when all goes good', ()async{
    when(errorHandler.executeFunction<void>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(permissions.executeFunctionByValidateLocation<void>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(locator.gpsPosition).thenAnswer((_) async=> tPosition);
    when(repository.setFinalPosition(any)).thenAnswer((_)async=> Right(null));
    when(repository.getChosenFormulario()).thenAnswer((_) async => Right(tStorageFormulario));
    when(repository.setCampos(any)).thenAnswer((_)async=> Right(null));
    await useCase(CamposParams(campos: tBlocFormulario.campos));
    verify(errorHandler.executeFunction<void>(any));
    verify(permissions.executeFunctionByValidateLocation(any));
    verify(locator.gpsPosition);
    verify(repository.setFinalPosition(tPosition));
    verify(repository.getChosenFormulario());
    verify(repository.setChosenFormulario(tBlocFormulario));
    verify(repository.setCampos(tBlocFormulario));
    verify(repository.endChosenFormulario());
  });

  test('should return the expected value when all goes good', ()async{
    when(errorHandler.executeFunction<void>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(permissions.executeFunctionByValidateLocation<void>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(repository.setFinalPosition(any)).thenAnswer((_)async=> Right(null));
    when(locator.gpsPosition).thenAnswer((_) async=> tPosition);
    when(repository.getChosenFormulario()).thenAnswer((_) async => Right(tStorageFormulario));
    when(repository.setCampos(any)).thenAnswer((_)async=> Right(null));
    final result = await useCase(CamposParams(campos: tBlocFormulario.campos));
    expect(result, Right(null));
  });

  test('should call the expected methods when setFinalPosition goes bad', ()async{
    when(errorHandler.executeFunction<void>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(permissions.executeFunctionByValidateLocation<void>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(locator.gpsPosition).thenAnswer((_) async=> tPosition);
    when(repository.setFinalPosition(any)).thenAnswer((_) async => Left(ServerFailure(type: ServerFailureType.NORMAL)));
    when(repository.getChosenFormulario()).thenAnswer((_) async => Right(tStorageFormulario));
    await useCase(CamposParams(campos: tBlocFormulario.campos));
    verify(errorHandler.executeFunction<void>(any));
    verify(permissions.executeFunctionByValidateLocation(any));
    verify(locator.gpsPosition);
    verify(repository.setFinalPosition(tPosition));
    verifyNever(repository.getChosenFormulario());
    verifyNever(repository.setChosenFormulario(any));
    verifyNever(repository.setCampos(any));
    verifyNever(repository.endChosenFormulario());
  });

  test('should return the expected value when setFinalPosition goes bad', ()async{
    when(errorHandler.executeFunction<void>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(permissions.executeFunctionByValidateLocation<void>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(locator.gpsPosition).thenAnswer((_) async=> tPosition);
    when(repository.setFinalPosition(any)).thenAnswer((_) async => Left(ServerFailure(type: ServerFailureType.NORMAL)));
    when(repository.getChosenFormulario()).thenAnswer((_) async => Right(tStorageFormulario));
    final result = await useCase(CamposParams(campos: tBlocFormulario.campos));
    expect(result, Left(ServerFailure(type: ServerFailureType.NORMAL)));
  });

  test('should return the expected value when setCampos goes bad', ()async{
    when(errorHandler.executeFunction<void>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(permissions.executeFunctionByValidateLocation<void>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(locator.gpsPosition).thenAnswer((_) async=> tPosition);
    when(repository.setFinalPosition(any)).thenAnswer((_)async=> Right(null));
    when(repository.getChosenFormulario()).thenAnswer((_) async => Right(tStorageFormulario));
    when(repository.setCampos(any)).thenAnswer((_) async => Left(ServerFailure(type: ServerFailureType.NORMAL)));
    final result = await useCase(CamposParams(campos: tBlocFormulario.campos));
    expect(result, Left(ServerFailure(type: ServerFailureType.NORMAL)));
  });

}

List<Formulario> _getFormulariosFromFixtures(){
  final String stringF = callFixture('formularios.json');
  final List<Map<String, dynamic>> jsonF = jsonDecode(stringF).cast<Map<String, dynamic>>();
  return formulariosFromJson(jsonF);
}