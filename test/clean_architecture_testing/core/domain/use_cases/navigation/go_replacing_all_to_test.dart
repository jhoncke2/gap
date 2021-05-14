import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_replacing_all_to.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_to.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';

class MockNavigationRepository extends Mock implements NavigationRepository{}
class MockCustomNavigator extends Mock implements CustomNavigator{}

GoReplacingAllTo useCase;
MockCustomNavigator navigator;
MockNavigationRepository repository;

void main(){
  setUp((){
    repository = MockNavigationRepository();
    navigator = MockCustomNavigator();
    useCase = GoReplacingAllTo(
      navigator: navigator,
      navRepository: repository
    );
  });

  group('goReplacingAllTo', (){
    NavigationRoute tNavRoute;
    setUp((){
      tNavRoute = NavigationRoute.Formularios;
    });
    test('should call the specified methods', ()async{
      when(repository.replaceAllNavRoutesForNew(any)).thenAnswer((_) async => Right(null));
      await useCase.call(NavigationParams(navRoute: tNavRoute));
      verify(repository.replaceAllNavRoutesForNew(tNavRoute));
    });
  });
}