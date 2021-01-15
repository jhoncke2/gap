import 'dart:async';

import 'package:bloc/bloc.dart';
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
      yield _currentYieldedState;
    }else if(event is ChangeShowedVisitsStep){
      final VisitStep newShowedVisitsSetp = event.newShowedVisitsSetp;
      yield state.copyWith(currentShowedVisitsStep: newShowedVisitsSetp);
    }
  }

  void _setVisits(SetVisits event){
    final List<Visit> visits = event.visits;
    final List<Visit> pendientesVisits = [];
    final List<Visit> realizadasVisits = [];
    visits.forEach((Visit visit) {
      if(visit.state == VisitStep.Pendiente)
        pendientesVisits.add(visit);
      else if(visit.state == VisitStep.Realizada)
        realizadasVisits.add(visit);
    });
    _currentYieldedState = state.copyWith(
      visitsAreLoaded: true, 
      visits: visits, 
      pendientesVisits: pendientesVisits,
      realizadasVisits: realizadasVisits
    );
  }
}
