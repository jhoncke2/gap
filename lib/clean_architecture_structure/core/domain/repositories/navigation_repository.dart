import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/navigation/navigation_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';

abstract class NavigationRepository{
  Future<Either<Failure, void>> loadRoute();
  Future<Either<Failure, void>> setNavRoute(NavigationRoute navRoute);
  Future<Either<Failure, void>> replaceAllNavRoutesForNew(NavigationRoute navRoute);
  Future<Either<Failure, void>> pop();
  Future<Either<Failure, NavigationRoute>> getCurrentRoute();
}

class NavigationRepositoryImpl implements NavigationRepository{
  final NavigationLocalDataSource localDataSource;
  final CustomNavigator customNavigator;
  NavigationRepositoryImpl({
    @required this.localDataSource,
    @required this.customNavigator
  });

  @override
  Future<Either<Failure, void>> loadRoute()async{
    try{
      final List<NavigationRoute> navRoutes = await localDataSource.getNavRoutes();
      await customNavigator.navigateReplacingTo(navRoutes.last);
      return Right(null);
    }on StorageException catch(exc){
      return Left(StorageFailure(excType: exc.type));
    }
  }

  @override
  Future<Either<Failure, void>> setNavRoute(NavigationRoute navRoute)async{
    try{
      await customNavigator.navigateReplacingTo(navRoute);
      await localDataSource.setNavRoute(navRoute);
      return Right(null);
    }on StorageException catch(exc){
      return Left(StorageFailure(excType: exc.type));
    }
  }

  @override
  Future<Either<Failure, void>> replaceAllNavRoutesForNew(NavigationRoute navRoute)async{
    try{
      await customNavigator.navigateReplacingTo(navRoute);
      await localDataSource.removeNavRoutes();
      await localDataSource.setNavRoute(navRoute);
      return Right(null);
    }on StorageException catch(exc){
      return Left(StorageFailure(excType: exc.type));
    }
  }

  @override
  Future<Either<Failure, void>> pop()async{
    try{
      final List<NavigationRoute> navRoutes = await localDataSource.getNavRoutes();
      if(navRoutes.length > 1){
        await localDataSource.removeLast();
        await customNavigator.navigateReplacingTo(navRoutes[navRoutes.length - 2]);
      }
      return Right(null);
    }on StorageException catch(exc){
      return Left(StorageFailure(excType: exc.type));
    }
  }
  
  @override
  Future<Either<Failure, NavigationRoute>> getCurrentRoute()async{
    try{
      final List<NavigationRoute> navRoutes = await localDataSource.getNavRoutes();
      return Right(navRoutes.last);
    }on StorageException catch(exc){
      return Left(StorageFailure(excType: exc.type));
    }
  
  }
  
}