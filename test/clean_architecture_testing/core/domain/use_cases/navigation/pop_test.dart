import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/pop.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';


class MockCustomNavigator extends Mock implements CustomNavigator{}
class MockNavigationRepository extends Mock implements NavigationRepository{}

Pop useCase;
MockCustomNavigator navigator;
MockNavigationRepository repository;


void main(){
  setUp((){
    repository = MockNavigationRepository();
    navigator = MockCustomNavigator();
    useCase = Pop(
      navigator: navigator, 
      navRepository: repository
    );
  });

  group('pop', (){
    NavigationRoute tCurrentRouteAfterPop;

    setUp((){
      tCurrentRouteAfterPop = NavigationRoute.Formularios;
    });

    test('should call the specified methods', ()async{
      when(repository.pop()).thenAnswer((_) async => Right(null));
      when(repository.getCurrentRoute()).thenAnswer((_) async => Right(tCurrentRouteAfterPop));
      await useCase.call(NoParams());
      verify(repository.pop());
      verify(repository.getCurrentRoute());
      verify(navigator.navigateReplacingTo(tCurrentRouteAfterPop));
    });

    test('should return Right(null) when all goes good', ()async{
      when(repository.pop()).thenAnswer((_) async => Right(null));
      when(repository.getCurrentRoute()).thenAnswer((_) async => Right(tCurrentRouteAfterPop));
      final result = await useCase.call(NoParams());
      expect(result, Right(null));

    });

    test('should return Left(X) when repository.pop() returns Left(X)', ()async{
      when(repository.pop()).thenAnswer((_) async => Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
      when(repository.getCurrentRoute()).thenAnswer((_) async => Right(tCurrentRouteAfterPop));
      final result = await useCase.call(NoParams());
      expect(result, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));

    });

    test('should return Left(X) when repository.getCurrentNavRoute() returns Left(X)', ()async{
      when(repository.pop()).thenAnswer((_) async => Right(null));
      when(repository.getCurrentRoute()).thenAnswer((_) async => Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
      final result = await useCase.call(NoParams());
      expect(result, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
  });
}