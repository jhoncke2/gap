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
    }else if(event is ChooseVisit){
      chooseVisit(event);
    }else if(event is ResetVisits){
      resetAllOfVisits();
    }else if(event is ResetDateFilter){
      resetDateFilter();      
    }
    yield _currentYieldedState;
  }

  @protected
  void setVisits(SetVisits event){
    final List<OldVisit> visits = event.visits;
    final List<OldVisit> pendientesVisits = [];
    final List<OldVisit> realizadasVisits = [];
    visits.forEach((OldVisit visit) {
      if(visit.stage == ProcessStage.Pendiente)
        pendientesVisits.add(visit);
      else if(visit.stage == ProcessStage.Realizada)
        realizadasVisits.add(visit);
    });
    _currentYieldedState = state.copyWith(
      visitsAreLoaded: true, 
      visits: visits, 
      pendientesVisits: pendientesVisits,
      realizadasVisits: realizadasVisits
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
    final List<OldVisit> filterVisits = _getVisitsWithSameDateThanFilter(filterDate);
    _currentYieldedState = state.copyWith(
      indexOfChosenFilterItem: filterItemIndex,
      filterDate: filterDate,
      visitsByFilterDate: filterVisits
    );
  }

  @protected
  List<OldVisit> _getVisitsWithSameDateThanFilter(DateTime filterDate){
    final List<OldVisit> currentShowedVisits = state.visitsByCurrentSelectedStep;
    final Iterable<OldVisit> filterVisits = currentShowedVisits.where(
      (OldVisit visit){
        final String visitDateString = visit.date.toString().split(' ')[0];
        final String filterDateString = filterDate.toString().split(' ')[0];
        return visitDateString == filterDateString;
      }
    );
    return filterVisits.toList();
  }

  @protected
  void chooseVisit(ChooseVisit event){
    final OldVisit chosenOne = event.chosenOne;
    _currentYieldedState = state.copyWith(chosenVisit: chosenOne);
    
  }

  

  @protected
  void resetAllOfVisits(){
    _currentYieldedState = state.reset();
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
}
