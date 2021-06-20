import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_replacing_all_to.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_to.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/pop.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final GoTo goTo;
  final GoReplacingAllTo goReplacingAllTo;
  final Pop pop;

  NavigationBloc({
    @required this.goTo,
    @required this.goReplacingAllTo,
    @required this.pop,    
  }) : super(InactiveNavigation());

  @override
  Stream<NavigationState> mapEventToState(
    NavigationEvent event,
  ) async* {
    yield OnNavigation();
    if(event is NavigateToEvent){
      await goTo(NavigationParams(navRoute: event.navigationRoute));
      yield Navigated(navRoute: event.navigationRoute);
    }else if(event is NavigateReplacingAllToEvent){
      await goReplacingAllTo(NavigationParams(navRoute: event.navigationRoute));
      yield Navigated(navRoute: event.navigationRoute);
    }else if(event is PopEvent){
      final eitherPop = await pop(NoParams());
      yield * eitherPop.fold((_)async*{
        //TODO: Implementar manejo de errores
      }, (newNavRoute)async*{
        yield Popped(navRoute: newNavRoute);
      });
    }
  }
}
