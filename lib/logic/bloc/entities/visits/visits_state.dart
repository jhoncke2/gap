part of 'visits_bloc.dart';

@immutable
class VisitsState {
  final bool visitsAreLoaded;
  final List<OldVisit> visits;
  final ProcessStage selectedStepInNav;
  final List<OldVisit> pendientesVisits;
  final List<OldVisit> realizadasVisits;
  final int indexOfChosenFilterItem;
  final DateTime filterDate;
  final List<OldVisit> visitsByFilterDate;
  final OldVisit chosenVisit;

  VisitsState({
    this.visitsAreLoaded = false,
    List<OldVisit> visits,
    ProcessStage selectedStepInNav,
    List<OldVisit> pendientesVisits,    
    List<OldVisit> realizadasVisits,
    int indexOfChosenFilterItem,
    DateTime filterDate,
    List<OldVisit> visitsByFilterDate,
    OldVisit chosenVisit   
  }):
    this.visits = visits??[],
    this.selectedStepInNav = selectedStepInNav??ProcessStage.Pendiente,
    this.pendientesVisits = pendientesVisits??[],
    this.realizadasVisits = realizadasVisits??[],
    this.indexOfChosenFilterItem = indexOfChosenFilterItem??null,
    this.filterDate = filterDate??null,
    this.visitsByFilterDate = visitsByFilterDate??null,
    this.chosenVisit = chosenVisit??null
    ;

  VisitsState copyWith({
    bool visitsAreLoaded,
    List<OldVisit> visits,
    ProcessStage selectedStepInNav,
    List<OldVisit> pendientesVisits,    
    List<OldVisit> realizadasVisits,
    int indexOfChosenFilterItem,    
    DateTime filterDate,
    List<OldVisit> visitsByFilterDate,
    OldVisit chosenVisit    
  })=>VisitsState(
    visitsAreLoaded: visitsAreLoaded??this.visitsAreLoaded,
    visits: visits??this.visits,
    selectedStepInNav: selectedStepInNav??this.selectedStepInNav, 
    pendientesVisits: pendientesVisits??this.pendientesVisits,    
    realizadasVisits: realizadasVisits??this.realizadasVisits,
    indexOfChosenFilterItem: indexOfChosenFilterItem??this.indexOfChosenFilterItem,
    filterDate: filterDate??this.filterDate,
    visitsByFilterDate: visitsByFilterDate??this.visitsByFilterDate,
    chosenVisit: chosenVisit??this.chosenVisit
  );

  VisitsState reset() => VisitsState();
  List<OldVisit> get currentShowedVisits{
    if(indexOfChosenFilterItem != null){
      return visitsByFilterDate;
    }else{
      if(selectedStepInNav == ProcessStage.Pendiente)
        return pendientesVisits;
      return realizadasVisits;
    }
  }

  List<OldVisit> get visitsByCurrentSelectedStep{
    if(selectedStepInNav == ProcessStage.Pendiente)
      return pendientesVisits;
    else if(selectedStepInNav == ProcessStage.Realizada)
      return realizadasVisits;
    else
      return null;
  }
}

