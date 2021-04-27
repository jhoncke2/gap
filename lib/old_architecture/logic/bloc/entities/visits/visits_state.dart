part of 'visits_bloc.dart';

@immutable
class VisitsState {
  final bool visitsAreLoaded;
  final List<VisitOld> visits;
  final ProcessStage selectedStepInNav;
  final List<VisitOld> pendientesVisits;
  final List<VisitOld> realizadasVisits;
  final int indexOfChosenFilterItem;
  final DateTime filterDate;
  final List<VisitOld> visitsByFilterDate;
  final VisitOld chosenVisit;
  final bool backing;
  final bool chosenVisitIsBlocked;

  VisitsState({
    this.visitsAreLoaded = false,
    bool visitsAreLocked,
    List<VisitOld> visits,
    ProcessStage selectedStepInNav,
    List<VisitOld> pendientesVisits,    
    List<VisitOld> realizadasVisits,
    int indexOfChosenFilterItem,
    DateTime filterDate,
    List<VisitOld> visitsByFilterDate,
    VisitOld chosenVisit,
    bool backing,
    bool chosenVisitIsBlocked
  }):
    this.visits = visits??[],
    this.selectedStepInNav = selectedStepInNav??ProcessStage.Pendiente,
    this.pendientesVisits = pendientesVisits??[],
    this.realizadasVisits = realizadasVisits??[],
    this.indexOfChosenFilterItem = indexOfChosenFilterItem??null,
    this.filterDate = filterDate??null,
    this.visitsByFilterDate = visitsByFilterDate??null,
    this.chosenVisit = chosenVisit??null,
    this.backing = backing??false,
    this.chosenVisitIsBlocked = chosenVisitIsBlocked??false
    ;

  VisitsState copyWith({
    bool visitsAreLoaded,
    List<VisitOld> visits,
    ProcessStage selectedStepInNav,
    List<VisitOld> pendientesVisits,    
    List<VisitOld> realizadasVisits,
    int indexOfChosenFilterItem,    
    DateTime filterDate,
    List<VisitOld> visitsByFilterDate,
    VisitOld chosenVisit,
    bool backing,
    bool chosenVisitIsBlocked
  })=>VisitsState(
    visitsAreLoaded: visitsAreLoaded??this.visitsAreLoaded,
    visits: visits??this.visits,
    selectedStepInNav: selectedStepInNav??this.selectedStepInNav, 
    pendientesVisits: pendientesVisits??this.pendientesVisits,    
    realizadasVisits: realizadasVisits??this.realizadasVisits,
    indexOfChosenFilterItem: indexOfChosenFilterItem??this.indexOfChosenFilterItem,
    filterDate: filterDate??this.filterDate,
    visitsByFilterDate: visitsByFilterDate??this.visitsByFilterDate,
    chosenVisit: chosenVisit??this.chosenVisit,
    backing: backing??this.backing,
    chosenVisitIsBlocked: chosenVisitIsBlocked??this.chosenVisitIsBlocked
  );

  VisitsState reset() => VisitsState();
  List<VisitOld> get currentShowedVisits{
    if(indexOfChosenFilterItem != null){
      return visitsByFilterDate;
    }else{
      if(selectedStepInNav == ProcessStage.Pendiente)
        return pendientesVisits;
      return realizadasVisits;
    }
  }

  List<VisitOld> get visitsByCurrentSelectedStep{
    if(selectedStepInNav == ProcessStage.Pendiente)
      return pendientesVisits;
    else if(selectedStepInNav == ProcessStage.Realizada)
      return realizadasVisits;
    else
      return null;
  }
}

