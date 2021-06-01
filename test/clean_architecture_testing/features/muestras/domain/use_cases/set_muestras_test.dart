import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestreo_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/use_cases/set_muestra.dart';
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
    Muestreo tMuestreo;
    int tSelectedRangoId;
    String tSelectedRango;
    List<double> tPesosTomados;
    setUp((){
      tMuestreo = _getMuestrasFromFixture();
      tSelectedRangoId = 1;
      tSelectedRango = tMuestreo.stringRangos[0];
      tPesosTomados = [1, 2, 3];
    });

    test('should call the repository method', ()async{
      when(repository.setMuestra(any, any, any)).thenAnswer((_) async => Right(null));
      await useCase.call(SetMuestraParams(muestreoId: tMuestreo.id, selectedRangoId: tSelectedRangoId, pesosTomados: tPesosTomados));
      verify(repository.setMuestra(tMuestreo.id, tSelectedRangoId, tPesosTomados));
    });

    test('should return the repository returned value', ()async{
      when(repository.setMuestra(any, any, any)).thenAnswer((_) async => Right(null));
      final result = await useCase.call(SetMuestraParams(selectedRangoId: tSelectedRangoId, muestreoId: tMuestreo.id, pesosTomados: tPesosTomados));
      expect(result, Right(null));
    });

    test('should return the repository returned value', ()async{
      when(repository.setMuestra(any, any, any)).thenAnswer((_) async => Left(ServerFailure(message: 'mensaje')));
      final result = await useCase.call(SetMuestraParams(selectedRangoId: tSelectedRangoId, muestreoId: tMuestreo.id, pesosTomados: tPesosTomados));
      expect(result, Left(ServerFailure(message: 'mensaje')));
    });
  });
}

Muestreo _getMuestrasFromFixture(){
  String stringMuestra = callFixture('muestreo.json');
  Map<String, dynamic> jsonMuestra = jsonDecode(stringMuestra);
  return MuestreoModel.fromJson(jsonMuestra);
}