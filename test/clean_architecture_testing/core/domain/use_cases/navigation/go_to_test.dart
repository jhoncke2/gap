import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_to.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockNavigationRepository extends Mock implements NavigationRepository{}
class MockCustomNavigator extends Mock implements CustomNavigator{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

GoTo useCase;
MockCustomNavigator navigator;
MockNavigationRepository repository;
MockUseCaseErrorHandler errorHandler;
void main(){
  setUp((){
    repository = MockNavigationRepository();
    navigator = MockCustomNavigator();
    errorHandler = MockUseCaseErrorHandler();
    useCase = GoTo(
      navigator: navigator,
      navRepository: repository,
      errorHandler: errorHandler
    );
  });

  group('goTo', (){
    NavigationRoute tNavRoute;
    setUp((){
      tNavRoute = NavigationRoute.AdjuntarFotosVisita;
    });
    test('should call the specified methods', ()async{
      when(errorHandler.executeFunction<void>(any)).thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
      when(repository.setNavRoute(any)).thenAnswer((_) async => Right(null));
      final result = await useCase.call(NavigationParams(navRoute: tNavRoute));
      verify(errorHandler.executeFunction<void>(any));
      verify(repository.setNavRoute(tNavRoute));
      expect(result, Right(null));
    });
  });
}