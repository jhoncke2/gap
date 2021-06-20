part of 'navigation_bloc.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();
  
  @override
  List<Object> get props => [this.runtimeType];
}

class InactiveNavigation extends NavigationState {}

class OnNavigation extends NavigationState {}

class Navigated extends NavigationState {
  final NavigationRoute navRoute;
  Navigated({
    @required this.navRoute
  });
  @override
  List<Object> get props => [...super.props, this.navRoute];
}

class Popped extends NavigationState{
  final NavigationRoute navRoute;
  Popped({
    @required this.navRoute
  });
  @override
  List<Object> get props => [...super.props, this.navRoute];
}