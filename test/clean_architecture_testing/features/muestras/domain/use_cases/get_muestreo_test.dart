import 'dart:convert';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestreo_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/get_muestras.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockMuestrasRepository extends Mock implements MuestrasRepository{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

GetMuestras useCase;
MockMuestrasRepository repository;
MockUseCaseErrorHandler errorHandler;

void main(){
  setUp((){
    errorHandler = MockUseCaseErrorHandler();
    repository = MockMuestrasRepository();
    useCase = GetMuestras(repository: repository, errorHandler: errorHandler);
  });

  group('call', (){
    Muestreo tMuestra;

    setUp((){
      tMuestra = _getMuestraFromFixture();
      when(errorHandler.executeFunction<Muestreo>(any)).thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
    });

    test('should get the muestras from the repository', ()async{
      when(repository.getMuestreo()).thenAnswer((_) async => Right(tMuestra));
      await useCase.call(NoParams());
      verify(errorHandler.executeFunction<Muestreo>(any));
      verify(repository.getMuestreo());
    });

    test('should return the repository result', ()async{
      when(repository.getMuestreo()).thenAnswer((_) async => Right(tMuestra));
      final result = await useCase.call(NoParams());
      expect(result, Right(tMuestra));
    });

    test('should get the repository result', ()async{
      when(repository.getMuestreo()).thenAnswer((_) async => Left(ServerFailure(message: 'mensajito')));
      final result = await useCase.call(NoParams());
      expect(result, Left(ServerFailure(message: 'mensajito')));
    });
  });
}

Muestreo _getMuestraFromFixture(){
  String stringMuestra = callFixture('muestreo.json');
  Map<String, dynamic> jsonMuestra = jsonDecode(stringMuestra);
  return MuestreoModel.fromRemoteJson(jsonMuestra);
}