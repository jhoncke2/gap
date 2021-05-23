import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/visits_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/features/visits/domain/use_cases/set_chosen_visit.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockVisitsRepository extends Mock implements VisitsRepository{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

SetChosenVisit useCase;
MockVisitsRepository repository;
MockUseCaseErrorHandler errorHandler;
void main(){
  setUp((){
    errorHandler = MockUseCaseErrorHandler();
    repository = MockVisitsRepository();
    useCase = SetChosenVisit(
      repository: repository,
      errorHandler: errorHandler
    );
  });
  
  group('call', (){
    Visit tVisit;
    setUp((){
      tVisit = VisitModel.fromJson(
        jsonDecode( callFixture('visits.json') ).cast<Map<String, dynamic>>()[0]
      );
    });

    test('should call the repository method on the error handler and return the repository return', ()async{
      when(repository.setChosenVisit(any)).thenAnswer((_) async => Right(null));
      when(errorHandler.executeFunction(any)).thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
      final result = await useCase(ChosenVisitParams(chosenVisit: tVisit));
      verify(errorHandler.executeFunction(any));
      verify(repository.setChosenVisit(tVisit));
      expect(result, Right(null));
    });
  });
}