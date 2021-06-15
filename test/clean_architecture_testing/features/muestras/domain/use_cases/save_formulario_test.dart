import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/save_formulario.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockMuestrasRepository extends Mock implements MuestrasRepository{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

SaveFormulario useCase;
MockMuestrasRepository repository;
MockUseCaseErrorHandler errorHandler;

void main(){
  setUp((){
    errorHandler = MockUseCaseErrorHandler();
    repository = MockMuestrasRepository();
    useCase = SaveFormulario(
      repository: repository,
      errorHandler: errorHandler
    );
  });

  group('call', (){
    int tMuestreoId;
    Formulario tFormulario;
    String tForularioType;
    setUp((){
      tMuestreoId = 1;
      tFormulario = _getFormularioFromxFixture();
      tForularioType = 'Pos';
    });

    test('should call the repository specified method and the errorHandler specified method', ()async{
      when(repository.setFormulario(any, any, any)).thenAnswer((_) async => Right(null));
      when(errorHandler.executeFunction(any)).thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
      await useCase(SaveFormularioParams(muestreoId: tMuestreoId, formulario: tFormulario, formularioType: tForularioType));
      verify(errorHandler.executeFunction(any));
      verify(repository.setFormulario(tMuestreoId, tFormulario, tForularioType));
      
    });
  });
}

Formulario _getFormularioFromxFixture(){
  final String stringFs = callFixture('formularios.json');
  final List<Map<String, dynamic>> jsonFs = jsonDecode(stringFs).cast<Map<String, dynamic>>();
  return FormularioModel.fromJson(jsonFs[0]);
}