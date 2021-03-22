part of 'visits_bloc.dart';

@immutable
class VisitsState {
  final bool visitsAreLoaded;
  final List<Visit> visits;
  final ProcessStage selectedStepInNav;
  final List<Visit> pendientesVisits;
  final List<Visit> realizadasVisits;
  final int indexOfChosenFilterItem;
  final DateTime filterDate;
  final List<Visit> visitsByFilterDate;
  final Visit chosenVisit;
  final bool backing;
  final bool chosenVisitIsBlocked;

  VisitsState({
    this.visitsAreLoaded = true,
    List<Visit> visits,
    ProcessStage selectedStepInNav,
    List<Visit> pendientesVisits,    
    List<Visit> realizadasVisits,
    int indexOfChosenFilterItem,
    DateTime filterDate,
    List<Visit> visitsByFilterDate,
    Visit chosenVisit,
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
    List<Visit> visits,
    ProcessStage selectedStepInNav,
    List<Visit> pendientesVisits,    
    List<Visit> realizadasVisits,
    int indexOfChosenFilterItem,    
    DateTime filterDate,
    List<Visit> visitsByFilterDate,
    Visit chosenVisit,
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
  List<Visit> get currentShowedVisits{
    if(indexOfChosenFilterItem != null){
      return visitsByFilterDate;
    }else{
      if(selectedStepInNav == ProcessStage.Pendiente)
        return pendientesVisits;
      return realizadasVisits;
    }
  }

  List<Visit> get visitsByCurrentSelectedStep{
    if(selectedStepInNav == ProcessStage.Pendiente)
      return pendientesVisits;
    else if(selectedStepInNav == ProcessStage.Realizada)
      return realizadasVisits;
    else
      return null;
  }
}

