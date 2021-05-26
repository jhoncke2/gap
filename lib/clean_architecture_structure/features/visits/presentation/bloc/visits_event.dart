part of 'visits_bloc.dart';

abstract class VisitsEvent extends Equatable {
  const VisitsEvent();

  @override
  List<Object> get props => [];
}

class LoadVisits extends VisitsEvent{}

class ChooseVisit extends VisitsEvent{
  final Visit visit;

  ChooseVisit({
    @required this.visit
  });
}

class LoadChosenVisit extends VisitsEvent{}