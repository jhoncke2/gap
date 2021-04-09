import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:meta/meta.dart';

part 'visits_event.dart';
part 'visits_state.dart';

class VisitsBloc extends Bloc<VisitsEvent, VisitsState> {
  VisitsState _currentYieldedState;
  VisitsBloc() : super(VisitsState());

  @override
  Stream<VisitsState> mapEventToState(
    VisitsEvent event,
  ) async* {
    if(event is SetVisits){
      setVisits(event);
    }else if(event is ChangeSelectedStepInNav){
      changeSelectedStepInNav(event);
    }else if(event is ChangeDateFilterItem){
      changeDateFilterItem(event);
    }else if(event is ResetDateFilter){
      resetDateFilter();      
    }else if(event is ChooseVisit){
      chooseVisit(event);
    }else if(event is ChangeChosenVisitBlocking){
      _changeChosenVisitBlocking(event);
    }else if(event is ResetVisits){
      resetAllOfVisits();
    }
    yield _currentYieldedState;
  }

  @protected
  void setVisits(SetVisits event){
    final List<Visit> visits = event.visits;
    final List<Visit> pendientesVisits = [];
    final List<Visit> realizadasVisits = [];
    visits.forEach((Visit visit) {
      if(visit.stage == ProcessStage.Pendiente)
        pendientesVisits.add(visit);
      else if(visit.stage == ProcessStage.Realizada)
        realizadasVisits.add(visit);
    });
    _currentYieldedState = state.copyWith(
      visitsAreLoaded: true, 
      visits: visits, 
      pendientesVisits: pendientesVisits,
      realizadasVisits: realizadasVisits,
      backing: false
    );
  }

  @protected
  void changeSelectedStepInNav(ChangeSelectedStepInNav event){
    final ProcessStage newSelectedMenuStage = event.newSelectedMenuStage;
    _currentYieldedState = state.copyWith(selectedStepInNav: newSelectedMenuStage);
  }

  @protected
  void changeDateFilterItem(ChangeDateFilterItem event){
    final int filterItemIndex = event.filterItemIndex;
    final DateTime filterDate = event.filterDate;
    final List<Visit> filterVisits = _getVisitsWithSameDateThanFilter(filterDate);
    _currentYieldedState = state.copyWith(
      indexOfChosenFilterItem: filterItemIndex,
      filterDate: filterDate,
      visitsByFilterDate: filterVisits
    );
  }

  @protected
  List<Visit> _getVisitsWithSameDateThanFilter(DateTime filterDate){
    final List<Visit> currentShowedVisits = state.visitsByCurrentSelectedStep;
    final Iterable<Visit> filterVisits = currentShowedVisits.where(
      (Visit visit){
        final String visitDateString = visit.date.toString().split(' ')[0];
        final String filterDateString = filterDate.toString().split(' ')[0];
        return visitDateString == filterDateString;
      }
    );
    return filterVisits.toList();
  }

  @protected
  void resetDateFilter(){
    _currentYieldedState = VisitsState(
      visitsAreLoaded: state.visitsAreLoaded,
      visits: state.visits,
      selectedStepInNav: state.selectedStepInNav,
      pendientesVisits: state.pendientesVisits,
      realizadasVisits: state.realizadasVisits,
      chosenVisit: state.chosenVisit
    );
  }

  @protected
  void chooseVisit(ChooseVisit event){
    final Visit chosenOne = event.chosenOne;
    final List<Visit> visits = state.visits;
    _addChosenVisit(chosenOne, visits);
    _currentYieldedState = state.copyWith(chosenVisit: chosenOne, visits: visits);
  }

  void _addChosenVisit(Visit chosenOne, List<Visit> visits){
    int chosenIndex = visits.indexWhere((element) => element.id == chosenOne.id);
    if(chosenIndex != -1)
      visits[chosenIndex] = chosenOne;
    else
      visits.add(chosenOne);
  }

  void _changeChosenVisitBlocking(ChangeChosenVisitBlocking event){
    _currentYieldedState = state.copyWith(chosenVisitIsBlocked: event.isBlocked);
  }

  @protected
  void resetAllOfVisits(){
    _currentYieldedState = state.reset();
  }
}
