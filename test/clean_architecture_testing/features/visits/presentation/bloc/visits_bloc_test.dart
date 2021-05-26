import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/clean_architecture_structure/features/visits/presentation/bloc/visits_bloc.dart';
import 'package:gap/clean_architecture_structure/features/visits/domain/use_cases/get_chosen_visit.dart';
import 'package:gap/clean_architecture_structure/features/visits/domain/use_cases/get_visits.dart';
import 'package:gap/clean_architecture_structure/features/visits/domain/use_cases/set_chosen_visit.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockGetVisits extends Mock implements GetVisits{}
class MockSetChosenVisit extends Mock implements SetChosenVisit{}
class MockGetChosenVisit extends Mock implements GetChosenVisit{}

VisitsBloc bloc;
MockGetVisits getVisits;
MockSetChosenVisit setChosenVisit;
MockGetChosenVisit getChosenVisit;

void main(){
  setUp((){
    getChosenVisit = MockGetChosenVisit();
    setChosenVisit = MockSetChosenVisit();
    getVisits = MockGetVisits();
    bloc = VisitsBloc(
      getVisits: getVisits,
      setChosenVisit: setChosenVisit,
      getChosenVisit: getChosenVisit
    );
  });

  test('bloc initialization', ()async{
    expect(bloc.state, VisitsEmpty());
  });

  group('loadVisits', (){
    List<Visit> tVisits;

    setUp((){
      tVisits = getVisitsFromFixture();
    });
    test('should call the useCase', ()async{
      when(getVisits.call(any)).thenAnswer((_) async => Right(tVisits));
      bloc.add(LoadVisits());
      await untilCalled(getVisits.call(any));
      verify(getVisits(NoParams()));
    });

    test('should yield the specified states when all goes good.', ()async{
      when(getVisits.call(any)).thenAnswer((_) async => Right(tVisits));
      final expectedOrderedStates = [
        LoadingVisits(),
        OnVisits(visits: tVisits)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(LoadVisits());
    });
  });

  group('chooseVisit', (){
    Visit tVisit;
    setUp((){
      tVisit = getVisitsFromFixture()[0];
    });

    test('should call the useCase', ()async{
      bloc.add(ChooseVisit(visit: tVisit));
      await untilCalled(setChosenVisit.call(any));
      verify(setChosenVisit(ChosenVisitParams(chosenVisit: tVisit)));
    });

    test('should yield the specified states when all goes good.', ()async{
      when(setChosenVisit.call(any)).thenAnswer((_) async => Right(null));
      final expectedOrderedStates = [
        LoadingVisits(),
        OnVisitDetail(visit: tVisit)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(ChooseVisit(visit: tVisit));
    });
  });

  group('loadChosenVisit', (){
    Visit tVisit;
    setUp((){
      tVisit = getVisitsFromFixture()[0];
    });

    test('should call the useCase', ()async{
      when(getChosenVisit.call(any)).thenAnswer((_) async => Right(tVisit));
      bloc.add(LoadChosenVisit());
      await untilCalled(getChosenVisit.call(any));
      verify(getChosenVisit(NoParams()));
    });

    test('should yield the specified states when all goes good.', ()async{
      when(getChosenVisit.call(any)).thenAnswer((_) async => Right(tVisit));
      final expectedOrderedStates = [
        LoadingVisits(),
        OnVisitDetail(visit: tVisit)
      ];
      expectLater(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(LoadChosenVisit());
    });
  });
}

List<Visit> getVisitsFromFixture(){
  return visitsFromRemoteJson(
    jsonDecode(
      callFixture('visits.json')
    ).cast<Map<String, dynamic>>()
  );
}