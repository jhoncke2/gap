import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_to.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockNavigationRepository extends Mock implements NavigationRepository{}
class MockCustomNavigator extends Mock implements CustomNavigator{}

GoTo useCase;
MockCustomNavigator navigator;
MockNavigationRepository repository;

void main(){
  setUp((){
    repository = MockNavigationRepository();
    navigator = MockCustomNavigator();
    useCase = GoTo(
      navigator: navigator,
      navRepository: repository
    );
  });

  group('goTo', (){
    NavigationRoute tNavRoute;
    setUp((){
      tNavRoute = NavigationRoute.AdjuntarFotosVisita;
    });
    test('should call the specified methods', ()async{
      when(repository.setNavRoute(any)).thenAnswer((_) async => Right(null));
      await useCase.call(NavigationParams(navRoute: tNavRoute));
      verify(repository.setNavRoute(tNavRoute));
    });
  });
}