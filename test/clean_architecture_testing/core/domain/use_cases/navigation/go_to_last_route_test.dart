import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_to_last_route.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:mockito/mockito.dart';

class MockNavigationRepository extends Mock implements NavigationRepository{}
class MockCustomNavigator extends Mock implements CustomNavigator{}

GoToLastRoute useCase;
MockCustomNavigator navigator;
MockNavigationRepository repository;
void main(){
  setUp((){
    repository = MockNavigationRepository();
    navigator = MockCustomNavigator();
    useCase = GoToLastRoute(
      navigator: navigator,
      navRepository: repository,
    );
  });

  group('goToLastRoute', (){
    NavigationRoute tLastRoute;
    setUp((){
      tLastRoute = NavigationRoute.Visits;
    });

    test('should call the specified methods', ()async{
      when(repository.getCurrentRoute()).thenAnswer((_) async => Right(tLastRoute));
      await useCase.call(NoParams());
      verify(repository.getCurrentRoute());
      verify(navigator.navigateReplacingTo(tLastRoute));
    });

    test('should return Right(null) when all goes good', ()async{
      when(repository.getCurrentRoute()).thenAnswer((_) async => Right(tLastRoute));
      final result = await useCase.call(NoParams());
      expect(result, Right(null));
    });

    test('should return Left(X) when repository returns Left(X)', ()async{
      when(repository.getCurrentRoute()).thenAnswer((_) async => Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
      final result = await useCase.call(NoParams());
      expect(result, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });
  });
}