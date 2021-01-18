part of 'visits_bloc.dart';

@immutable
class VisitsState {
  final bool visitsAreLoaded;
  final List<Visit> visits;
  final VisitStep selectedStepInNav;
  final List<Visit> pendientesVisits;
  final List<Visit> realizadasVisits;
  final int indexOfChosenFilterItem;
  final DateTime filterDate;
  final List<Visit> visitsByFilterDate;
  final Visit chosenVisit;

  VisitsState({
    this.visitsAreLoaded = false,
    List<Visit> visits,
    VisitStep selectedStepInNav,
    List<Visit> pendientesVisits,    
    List<Visit> realizadasVisits,
    int indexOfChosenFilterItem,
    DateTime filterDate,
    List<Visit> visitsByFilterDate,
    Visit chosenVisit   
  }):
    this.visits = visits??[],
    this.selectedStepInNav = selectedStepInNav??VisitStep.Pendiente,
    this.pendientesVisits = pendientesVisits??[],
    this.realizadasVisits = realizadasVisits??[],
    this.indexOfChosenFilterItem = indexOfChosenFilterItem??null,
    this.filterDate = filterDate??null,
    this.visitsByFilterDate = visitsByFilterDate??null,
    this.chosenVisit = chosenVisit??null
    ;

  VisitsState copyWith({
    bool visitsAreLoaded,
    List<Visit> visits,
    VisitStep selectedStepInNav,
    List<Visit> pendientesVisits,    
    List<Visit> realizadasVisits,
    int indexOfChosenFilterItem,    
    DateTime filterDate,
    List<Visit> visitsByFilterDate,
    Visit chosenVisit    
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
  List<Visit> get currentShowedVisits{
    if(indexOfChosenFilterItem != null){
      return visitsByFilterDate;
    }else{
      if(selectedStepInNav == VisitStep.Pendiente)
        return pendientesVisits;
      return realizadasVisits;
    }
  }

  List<Visit> get visitsByCurrentSelectedStep{
    if(selectedStepInNav == VisitStep.Pendiente)
      return pendientesVisits;
    else if(selectedStepInNav == VisitStep.Realizada)
      return realizadasVisits;
    else
      return null;
  }
}

