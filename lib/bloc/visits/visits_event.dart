part of 'visits_bloc.dart';

@immutable
abstract class VisitsEvent {}

class SetVisits extends VisitsEvent{
  final List<Visit> visits;
  SetVisits({
    @required this.visits
  });
}

class ChangeShowedVisitsStep extends VisitsEvent{
  final VisitStep newShowedVisitsSetp;
  ChangeShowedVisitsStep({
    @required this.newShowedVisitsSetp
  });
}
