import 'dart:convert';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/custom_position.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/usecase_permissions_manager.dart';
import 'package:gap/clean_architecture_structure/core/platform/locator.dart';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/choose_formulario.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockFormulariosRepository extends Mock implements FormulariosRepository{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}
class MockUseCasePermissionsManager extends Mock implements UseCasePermissionsManager{}
class MockCustomLocator extends Mock implements CustomLocator{}

ChooseFormulario useCase;
MockFormulariosRepository repository;
MockUseCaseErrorHandler errorHandler;
MockUseCasePermissionsManager permissions;
MockCustomLocator locator;

void main(){
  Formulario tFormulario;
  CustomPosition tInitialPosition;
  setUp((){
    permissions = MockUseCasePermissionsManager();
    errorHandler = MockUseCaseErrorHandler();
    repository = MockFormulariosRepository();
    locator = MockCustomLocator();
    useCase = ChooseFormulario(
      repository: repository, 
      errorHandler: errorHandler, 
      permissions: permissions,
      locator: locator
    );
    tFormulario = _getFormularioFromFixtures();
    tInitialPosition = CustomPosition(latitude: 1.0, longitude: 2.5);
    when(locator.gpsPosition).thenAnswer((_) async => tInitialPosition);
  });

  test('should call the specified methods', ()async{
    when(errorHandler.executeFunction<void>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(permissions.executeFunctionByValidateLocation<void>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    await useCase(ChooseFormularioParams(formulario: tFormulario));
    verify(repository.setChosenFormulario(tFormulario));
    verify(errorHandler.executeFunction<void>(any));
    verify(permissions.executeFunctionByValidateLocation<void>(any));
    verify(locator.gpsPosition);
    verify(repository.setInitialPosition(tInitialPosition));
  });

  test('should call the specified methods', ()async{
    when(errorHandler.executeFunction<void>(any))
      .thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    when(permissions.executeFunctionByValidateLocation(any))
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