import 'dart:convert';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/visits_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/features/visits/domain/use_cases/get_visits.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockVisitsRepository extends Mock implements VisitsRepository{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

GetVisits useCase;
MockVisitsRepository repository;
MockUseCaseErrorHandler errorHandler;

void main(){
  setUp((){
    errorHandler = MockUseCaseErrorHandler();
    repository = MockVisitsRepository();
    useCase = GetVisits(
      repository: repository,
      errorHandler: errorHandler
    );
  });

  group('call', (){
    List<Visit> tVisits;
    setUp((){
      tVisits = visitsFromRemoteJson( 
        jsonDecode( callFixture('visits.json') ).cast<Map<String, dynamic>>()
      );
    });

    test('should call the repository method on the errorHandler', ()async{
      when(repository.getVisits()).thenAnswer((_) async => Right(tVisits));
      when(errorHandler.executeFunction(any)).thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
      final result = await useCase(NoParams());
      verify(errorHandler.executeFunction<List<Visit>>(any));
      verify(repository.getVisits());
      expect(result, Right(tVisits));
    });
  });
}