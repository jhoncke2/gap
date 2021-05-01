import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/navigation/navigation_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockNavigationLocalDataSource extends Mock implements NavigationLocalDataSource{}
class MockCustomNavigator extends Mock implements CustomNavigator{}

MockNavigationLocalDataSource localDataSource;
MockCustomNavigator customNavigator;
NavigationRepositoryImpl repository;

void main(){
  setUp((){
    localDataSource = MockNavigationLocalDataSource();
    customNavigator = MockCustomNavigator();
    repository = NavigationRepositoryImpl(
      customNavigator: customNavigator,
      localDataSource: localDataSource
    );
  });

  group('loadRoute', (){
    List<NavigationRoute> tNavRoutes;
    setUp((){
      tNavRoutes = [NavigationRoute.Projects, NavigationRoute.ProjectDetail];
    });

    test('should get the tNavRoutes from the localDataSource and set the last on the customNavigator', ()async{
      when(localDataSource.getNavRoutes()).thenAnswer((_) async => tNavRoutes);
      await repository.loadRoute();
      verify(localDataSource.getNavRoutes());
      verify(customNavigator.navigateReplacingTo(tNavRoutes.last));
    });

    test('should return Right(null) when all goes good', ()async{
      when(localDataSource.getNavRoutes()).thenAnswer((_) async => tNavRoutes);
      final result = await repository.loadRoute();
      expect(result, Right(null));
    });

    test('should return Left(StorageFailure(X)) when localDataSource throws a StorageException(X)', ()async{
      when(localDataSource.getNavRoutes())..thenThrow(StorageException(type: StorageExceptionType.NORMAL));
      final result = await repository.loadRoute();
      expect(result, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
  });

  group('setNavRoute', (){
    NavigationRoute tNavRoute;
    setUp((){
      tNavRoute = NavigationRoute.Firmers;
    });
    test('should set the navRoute on the localDataSource and nav to it on the customNavigator', ()async{
      await repository.setNavRoute(tNavRoute);
      verify(customNavigator.navigateReplacingTo(tNavRoute));
      verify(localDataSource.setNavRoute(tNavRoute));
    });

    test('should return Right(null) when all goes good', ()async{
      final result = await repository.setNavRoute(tNavRoute);
      expect(result, Right(null));
    });

    test('should return Left(StorageFailure(X)) when localDataSource throws a StorageException(X)', ()async{
      when(localDataSource.setNavRoute(any)).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      final result = await repository.setNavRoute(tNavRoute);
      expect(result, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });
  });

  group('replaceAllNavRoutesForNew', (){
    NavigationRoute tNavRoute;
    setUp((){
      tNavRoute = NavigationRoute.Firmers;
    });
    test('''should nav to tNavRoute on customNavigator, reset the localDataSource 
    and set the tNavRoute''', ()async{
      await repository.replaceAllNavRoutesForNew(tNavRoute);
      verify(customNavigator.navigateReplacingTo(tNavRoute));
      verify(localDataSource.removeNavRoutes());
      verify(localDataSource.setNavRoute(tNavRoute));
    });

    test('should return Right(null) when all goes good', ()async{
      final result = await repository.replaceAllNavRoutesForNew(tNavRoute);
      expect(result, Right(null));
    });

    test('should return Left(StorageFailure(X)) when localDataSource throws a StorageException(X)', ()async{
      when(localDataSource.setNavRoute(any)).thenThrow(StorageException(type: StorageExceptionType.NORMAL));
      final result = await repository.replaceAllNavRoutesForNew(tNavRoute);
      expect(result, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
  });

  group('pop', (){
    List<NavigationRoute> tNavRoutes;
    List<NavigationRoute> tOnlyOneNavRoutes;
    setUp((){
      tNavRoutes = [NavigationRoute.Projects, NavigationRoute.ProjectDetail, NavigationRoute.Visits];
      tOnlyOneNavRoutes = [NavigationRoute.Projects];
    });

    test('should nav to the almost last navRoute of tNavRoutes, set the tUpdatedNavRoutes to the localDataSource', ()async{
      when(localDataSource.getNavRoutes()).thenAnswer((_) async => tNavRoutes);
      await repository.pop();
      verify(localDataSource.getNavRoutes());
      verify(localDataSource.removeLast());
      verify(customNavigator.navigateReplacingTo(tNavRoutes[tNavRoutes.length - 2]));
    });

    test('should not pop if the localDataSource returns only one navRoute', ()async{
      when(localDataSource.getNavRoutes()).thenAnswer((_) async => tOnlyOneNavRoutes);
      await repository.pop();
      verify(localDataSource.getNavRoutes());
      verifyNever(localDataSource.removeLast());
      verifyNever(customNavigator.navigateReplacingTo(any));
    });

    test('should return Right(null) when all goes good', ()async{
      when(localDataSource.getNavRoutes()).thenAnswer((_) async => tNavRoutes);
      final result = await repository.pop();
      expect(result, Right(null));
    });

    test('should return Left(StorageFailure(X)) when localDataSource throws a StorageException(X)', ()async{
      when(localDataSource.getNavRoutes()).thenThrow(StorageException(type: StorageExceptionType.NORMAL));
      final result = await repository.pop();
      expect(result, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
  });

  group('getCurrentRoute', (){
    List<NavigationRoute> tNavRoutes;
    setUp((){
      tNavRoutes = [NavigationRoute.Projects, NavigationRoute.ProjectDetail, NavigationRoute.Visits];
    });

    test('should obtain the navRoutes from the localDataSource', ()async{
      when(localDataSource.getNavRoutes()).thenAnswer((_) async => tNavRoutes);
      await repository.getCurrentRoute();
      verify(localDataSource.getNavRoutes());
    });

    test('should return Right(last nav route of tNavRoutes) when all goes good', ()async{
      when(localDataSource.getNavRoutes()).thenAnswer((_) async => tNavRoutes);
      final result = await repository.getCurrentRoute();
      expect(result, Right(tNavRoutes.last));
    });
    
    test('should return Left(StorageFailure(X)) when localDataSource throws a StorageException(X)', ()async{
      when(localDataSource.getNavRoutes()).thenThrow(StorageException(type: StorageExceptionType.NORMAL));
      final result = await repository.getCurrentRoute();
      expect(result, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
  });
}
