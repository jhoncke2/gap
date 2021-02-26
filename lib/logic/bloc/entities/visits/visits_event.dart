part of 'visits_bloc.dart';

@immutable
abstract class VisitsEvent {}

class SetVisits extends VisitsEvent{
  final List<OldVisit> visits;
  SetVisits({
    @required this.visits,
  });
}

class ChangeSelectedStepInNav extends VisitsEvent{
  final ProcessStage newSelectedMenuStage;
  ChangeSelectedStepInNav({
    @required this.newSelectedMenuStage
  });
}

class ChangeDateFilterItem extends VisitsEvent{
  final int filterItemIndex;
  final DateTime filterDate;
  ChangeDateFilterItem({
    @required this.filterItemIndex,
    @required this.filterDate
  });
}

class ChooseVisit extends VisitsEvent{
  final OldVisit chosenOne;
  ChooseVisit({
    @required this.chosenOne,
  });
}

class ResetVisits extends VisitsEvent{}

class ResetDateFilter extends VisitsEvent{}
