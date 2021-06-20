import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_replacing_all_to.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_to.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/pop.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockGoTo extends Mock implements GoTo{}
class MockPop extends Mock implements Pop{}
class MockGoReplacingAllTo extends Mock implements GoReplacingAllTo{}

NavigationBloc bloc;
MockGoReplacingAllTo goReplacingAllTo;
MockGoTo goTo;
MockPop pop;

void main(){
  setUp((){
    pop = MockPop();
    goReplacingAllTo = MockGoReplacingAllTo();
    goTo = MockGoTo();
    bloc = NavigationBloc(
      goTo: goTo,
      goReplacingAllTo: goReplacingAllTo,
      pop: pop
    );
  });

  test('should init with InactiveNavigation state', ()async{
    expect(bloc.state, InactiveNavigation());
  });

  group('navigateTo', (){
    NavigationRoute tNavigationRoute;
    setUp((){
      tNavigationRoute = NavigationRoute.AdjuntarFotosVisita;
    });

    test('should call the specified useCase', ()async{
      bloc.add(NavigateToEvent(navigationRoute: tNavigationRoute));
      await untilCalled(goTo.call(any));
      verify(goTo.call(NavigationParams(navRoute: tNavigationRoute)));
    });
    
    test('should yield the specified ordered states when all goes good', ()async{
      final expectedOrderedStates = [
        OnNavigation(),
        Navigated(navRoute: tNavigationRoute)
      ];
      expect(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(NavigateToEvent(navigationRoute: tNavigationRoute));
    });
  });

  group('navigateReplacingAllTo', (){
    NavigationRoute tNavigationRoute;
    setUp((){
      tNavigationRoute = NavigationRoute.AdjuntarFotosVisita;
    });

    test('should call the specified useCase', ()async{
      bloc.add(NavigateReplacingAllToEvent(navigationRoute: tNavigationRoute));
      await untilCalled(goReplacingAllTo.call(any));
      verify(goReplacingAllTo.call(NavigationParams(navRoute: tNavigationRoute)));
    });

    test('should yield the specified ordered states when all goes good', ()async{
      final expectedOrderedStates = [
        OnNavigation(),
        Navigated(navRoute: tNavigationRoute)
      ];
      expect(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(NavigateReplacingAllToEvent(navigationRoute: tNavigationRoute));
    });
  });

  group('pop', (){
    NavigationRoute afterPopRoute;
    setUp((){
      afterPopRoute = NavigationRoute.Formularios;
      when(pop.call(any)).thenAnswer((_) async => Right(afterPopRoute));
    });

    test('should call the specified useCase', ()async{
      bloc.add(PopEvent());
      await untilCalled(pop.call(any));
      verify(pop.call(NoParams()));
    });

    test('should yield the specified ordered states when all goes good', ()async{
      final expectedOrderedStates = [
        OnNavigation(),
        Popped(navRoute: afterPopRoute)
      ];
      expect(bloc.asBroadcastStream(), emitsInOrder(expectedOrderedStates));
      bloc.add(PopEvent());
    });
  });
}