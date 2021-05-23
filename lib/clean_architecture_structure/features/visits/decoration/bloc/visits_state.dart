part of 'visits_bloc.dart';

abstract class VisitsState extends Equatable {
  const VisitsState();
  
  @override
  List<Object> get props => [this.runtimeType];
}

class VisitsEmpty extends VisitsState {}

class LoadingVisits extends VisitsState {}

class OnVisits extends VisitsState {
  final List<Visit> visits;

  OnVisits({
    @required this.visits
  });

  @override
  List<Object> get props => [...super.props, this.visits];
}

class OnVisitDetail extends VisitsState{
  final Visit visit;
  OnVisitDetail({
    @required this.visit
  });

  @override
  List<Object> get props => [...super.props, this.visit];
}