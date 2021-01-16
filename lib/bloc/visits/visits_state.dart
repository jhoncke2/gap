part of 'visits_bloc.dart';

@immutable
class VisitsState {
  final bool visitsAreLoaded;
  final List<Visit> visits;
  final VisitStep showedVisitsStep;
  final List<Visit> pendientesVisits;
  final List<Visit> realizadasVisits;
  final int indexOfChosenFilterItem;
  final DateTime filterDate;
  final List<Visit> visitsByFilterDate;
  final Visit chosenVisit;

  VisitsState({
    this.visitsAreLoaded = false,
    List<Visit> visits,
    VisitStep showedVisitsStep,
    List<Visit> pendientesVisits,    
    List<Visit> realizadasVisits,
    int indexOfChosenFilterItem,
    DateTime filterDate,
    List<Visit> visitsByFilterDate,
    Visit chosenVisit   
  }):
    this.visits = visits??[],
    this.showedVisitsStep = showedVisitsStep??VisitStep.Pendiente,
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
    VisitStep showedVisitsStep,
    List<Visit> pendientesVisits,    
    List<Visit> realizadasVisits,
    int indexOfChosenFilterItem,    
    DateTime filterDate,
    List<Visit> visitsByFilterDate,
    Visit chosenVisit    
  })=>VisitsState(
    visitsAreLoaded: visitsAreLoaded??this.visitsAreLoaded,
    visits: visits??this.visits,
    showedVisitsStep: showedVisitsStep??this.showedVisitsStep, 
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
      if(showedVisitsStep == VisitStep.Pendiente)
        return pendientesVisits;
      return realizadasVisits;
    }
  }
}

