import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestra_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/set_muestras.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockMuestrasRepository extends Mock implements MuestrasRepository{}

SetMuestra useCase;
MockMuestrasRepository repository;

void main(){
  setUp((){
    repository = MockMuestrasRepository();
    useCase = SetMuestra(repository: repository);
  });

  group('call', (){
    Muestra tMuestra;
    setUp((){
      tMuestra = _getMuestrasFromFixture();
    });

    test('should call the repository method', ()async{
      when(repository.setMuestra(any)).thenAnswer((_) async => Right(null));
      await useCase.call(MuestrasParams(muestra: tMuestra));
      verify(repository.setMuestra(tMuestra));
    });

    test('should return the repository returned value', ()async{
      when(repository.setMuestra(any)).thenAnswer((_) async => Right(null));
      final result = await useCase.call(MuestrasParams(muestra: tMuestra));
      expect(result, Right(null));
    });

    test('should return the repository returned value', ()async{
      when(repository.setMuestra(any)).thenAnswer((_) async => Left(ServerFailure(message: 'mensaje')));
      final result = await useCase.call(MuestrasParams(muestra: tMuestra));
      expect(result, Left(ServerFailure(message: 'mensaje')));
    });
  });
}

Muestra _getMuestrasFromFixture(){
  String stringMuestra = callFixture('muestra.json');
  Map<String, dynamic> jsonMuestra = jsonDecode(stringMuestra);
  return MuestraModel.fromJson(jsonMuestra);
}