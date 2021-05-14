part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class NavigateToEvent extends NavigationEvent{
  final NavigationRoute navigationRoute;

  NavigateToEvent({
    @required this.navigationRoute
  });
}

class NavigateReplacingAllToEvent extends NavigationEvent{
  final NavigationRoute navigationRoute;

  NavigateReplacingAllToEvent({
    @required this.navigationRoute
  });
}

class PopEvent extends NavigationEvent{ }