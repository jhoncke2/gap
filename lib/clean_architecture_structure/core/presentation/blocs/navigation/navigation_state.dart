part of 'navigation_bloc.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();
  
  @override
  List<Object> get props => [];
}

class InactiveNavigation extends NavigationState {}

class OnNavigation extends NavigationState {}

class Navigated extends NavigationState {}