import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_replacing_all_to.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_to.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';

class MockNavigationRepository extends Mock implements NavigationRepository{}
class MockCustomNavigator extends Mock implements CustomNavigator{}
class MockUseCaseErrorHandler extends Mock implements UseCaseErrorHandler{}

GoReplacingAllTo useCase;
MockCustomNavigator navigator;
MockNavigationRepository repository;
MockUseCaseErrorHandler errorHandler;

void main(){
  setUp((){
    repository = MockNavigationRepository();
    navigator = MockCustomNavigator();
    errorHandler = MockUseCaseErrorHandler();
    useCase = GoReplacingAllTo(
      navigator: navigator,
      navRepository: repository,
      errorHandler: errorHandler
    );
  });

  group('goReplacingAllTo', (){
    NavigationRoute tNavRoute;
    setUp((){
      tNavRoute = NavigationRoute.Formularios;
    });
    test('should call the specified methods', ()async{
      when(repository.replaceAllNavRoutesForNew(any)).thenAnswer((_) async => Right(null));
      when(errorHandler.executeFunction<void>(any)).thenAnswer((realInvocation) => realInvocation.positionalArguments[0]());
      final result = await useCase.call(NavigationParams(navRoute: tNavRoute));
      verify(errorHandler.executeFunction(any));
      verify(repository.replaceAllNavRoutesForNew(tNavRoute));
      expect(result, Right(null));
    });
  });
}