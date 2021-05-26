import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/features/visits/domain/use_cases/get_chosen_visit.dart';
import 'package:gap/clean_architecture_structure/features/visits/domain/use_cases/get_visits.dart';
import 'package:gap/clean_architecture_structure/features/visits/domain/use_cases/set_chosen_visit.dart';
import 'package:meta/meta.dart';
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';

part 'visits_event.dart';
part 'visits_state.dart';

class VisitsBloc extends Bloc<VisitsEvent, VisitsState> {

  final GetVisits getVisits;
  final SetChosenVisit setChosenVisit;
  final GetChosenVisit getChosenVisit;

  VisitsBloc({
    @required this.getVisits,
    @required this.setChosenVisit,
    @required this.getChosenVisit 
  }) : super(VisitsEmpty());

  @override
  Stream<VisitsState> mapEventToState(
    VisitsEvent event,
  ) async* {
    yield LoadingVisits();
    if(event is LoadVisits){
      final eitherVisits = await getVisits(NoParams());
      yield * eitherVisits.fold((l)async*{

      }, (visits)async*{
        yield OnVisits(visits: visits);
      });
    }else if(event is ChooseVisit){
      yield LoadingVisits();
      await setChosenVisit(ChosenVisitParams(chosenVisit: event.visit));
      yield OnVisitDetail(visit: event.visit);
    }else if(event is LoadChosenVisit){
      yield LoadingVisits();
      final eitherVisit = await getChosenVisit(NoParams());
      yield *eitherVisit.fold((l)async*{

      }, (visit)async*{
        yield OnVisitDetail(visit: visit);
      });
    }
  }
}
