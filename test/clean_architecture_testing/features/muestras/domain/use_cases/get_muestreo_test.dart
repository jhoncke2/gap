import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestreo_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/get_muestras.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockMuestrasRepository extends Mock implements MuestrasRepository{}

GetMuestras useCase;
MockMuestrasRepository repository;

void main(){
  setUp((){
    repository = MockMuestrasRepository();
    useCase = GetMuestras(repository: repository);
  });

  group('call', (){
    Muestreo tMuestra;

    setUp((){
      tMuestra = _getMuestraFromFixture();
    });

    test('should get the muestras from the repository', ()async{
      when(repository.getMuestreo()).thenAnswer((_) async => Right(tMuestra));
      await useCase.call(NoParams());
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
  return MuestreoModel.fromJson(jsonMuestra);
}