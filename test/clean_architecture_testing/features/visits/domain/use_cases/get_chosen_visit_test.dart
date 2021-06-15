import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/visits_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/features/visits/domain/use_cases/get_chosen_visit.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockVisitsRepository extends Mock implements VisitsRepository{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

GetChosenVisit useCase;
MockVisitsRepository repository;
MockUseCaseErrorHandler errorHandler;

void main(){
  setUp((){
    errorHandler = MockUseCaseErrorHandler();
    repository = MockVisitsRepository();
    useCase = GetChosenVisit(
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

    test('''should call the repository method on the errorHandler method 
    and return the repository response''', ()async{
      when(repository.getChosenVisit()).thenAnswer((_) async => Right(tVisit));
      when(errorHandler.executeFunction(any)).thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
      final result = await useCase(NoParams());
      verify(errorHandler.executeFunction<Visit>(any));
      verify(repository.getChosenVisit());
      expect(result, Right(tVisit));
    });
  });
}