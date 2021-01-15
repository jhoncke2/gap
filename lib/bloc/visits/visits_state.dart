part of 'visits_bloc.dart';

@immutable
class VisitsState {
  final bool visitsAreLoaded;
  final List<Visit> visits;
  final VisitStep currentShowedVisitsStep;
  final List<Visit> pendientesVisits;
  final List<Visit> realizadasVisits;

  VisitsState({
    this.visitsAreLoaded = false,
    List<Visit> visits,
    VisitStep currentShowedVisitsStep,
    List<Visit> pendientesVisits,    
    List<Visit> realizadasVisits
  }):
    this.visits = visits??null,
    this.currentShowedVisitsStep = currentShowedVisitsStep??VisitStep.Pendiente,
    this.pendientesVisits = pendientesVisits??null,
    this.realizadasVisits = realizadasVisits??null    
    ;

  VisitsState copyWith({
    bool visitsAreLoaded,
    List<Visit> visits,
    VisitStep currentShowedVisitsStep,
    List<Visit> pendientesVisits,    
    List<Visit> realizadasVisits
  })=>VisitsState(
    visitsAreLoaded: visitsAreLoaded??this.visitsAreLoaded,
    visits: visits??this.visits,
    currentShowedVisitsStep: currentShowedVisitsStep??this.currentShowedVisitsStep, 
    pendientesVisits: pendientesVisits??this.pendientesVisits,    
    realizadasVisits: realizadasVisits??this.realizadasVisits
  );
}

