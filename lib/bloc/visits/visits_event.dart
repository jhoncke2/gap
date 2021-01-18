part of 'visits_bloc.dart';

@immutable
abstract class VisitsEvent {}

class SetVisits extends VisitsEvent{
  final List<Visit> visits;
  SetVisits({
    @required this.visits,
  });
}

class ChangeSelectedStepInNav extends VisitsEvent{
  final VisitStep newSelectedStep;
  ChangeSelectedStepInNav({
    @required this.newSelectedStep
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
  final Visit chosenOne;
  ChooseVisit({
    @required this.chosenOne,
  });
}

class ResetAllOfVisits extends VisitsEvent{}

class ResetDateFilter extends VisitsEvent{}
