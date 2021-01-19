import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gap/enums/process_stage.dart';
import 'package:gap/models/visit.dart';
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
      _setVisits(event);
    }else if(event is ChangeSelectedStepInNav){
      _changeSelectedStepInNav(event);
    }else if(event is ChangeDateFilterItem){
      _changeDateFilterItem(event);
    }else if(event is ChooseVisit){
      _chooseVisit(event);
    }else if(event is ResetAllOfVisits){
      _resetAllOfVisits();
    }else if(event is ResetDateFilter){
      _resetDateFilter();      
    }
    yield _currentYieldedState;
  }

  void _setVisits(SetVisits event){
    final List<Visit> visits = event.visits;
    final List<Visit> pendientesVisits = [];
    final List<Visit> realizadasVisits = [];
    visits.forEach((Visit visit) {
      if(visit.currentStage == ProcessStage.Pendiente)
        pendientesVisits.add(visit);
      else if(visit.currentStage == ProcessStage.Realizada)
        realizadasVisits.add(visit);
    });
    _currentYieldedState = state.copyWith(
      visitsAreLoaded: true, 
      visits: visits, 
      pendientesVisits: pendientesVisits,
      realizadasVisits: realizadasVisits
    ); 
  }

  void _changeSelectedStepInNav(ChangeSelectedStepInNav event){
    final ProcessStage newSelectedMenuStage = event.newSelectedMenuStage;
    _currentYieldedState = state.copyWith(selectedStepInNav: newSelectedMenuStage);
  }

  void _changeDateFilterItem(ChangeDateFilterItem event){
    final int filterItemIndex = event.filterItemIndex;
    final DateTime filterDate = event.filterDate;
    final List<Visit> filterVisits = _getVisitsWithSameDateThanFilter(filterDate);
    _currentYieldedState = state.copyWith(
      indexOfChosenFilterItem: filterItemIndex,
      filterDate: filterDate,
      visitsByFilterDate: filterVisits
    );
  }

  void _chooseVisit(ChooseVisit event){
    final Visit chosenOne = event.chosenOne;
    _currentYieldedState = state.copyWith(chosenVisit: chosenOne);
  }

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

  void _resetAllOfVisits(){
    _currentYieldedState = state.reset();
  }

  void _resetDateFilter(){
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
