import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/navigation/navigation_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';

class NavigationRepositoryImpl implements NavigationRepository{
  final NavigationLocalDataSource localDataSource;
  NavigationRepositoryImpl({
    @required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> setNavRoute(NavigationRoute navRoute)async{
    try{
      await localDataSource.setNavRoute(navRoute);
      return Right(null);
    }on StorageException catch(exc){
      return Left(StorageFailure(excType: exc.type));
    }
  }

  @override
  Future<Either<Failure, void>> replaceAllNavRoutesForNew(NavigationRoute navRoute)async{
    try{
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
      if(navRoutes.length > 1)
        await localDataSource.removeLast();
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