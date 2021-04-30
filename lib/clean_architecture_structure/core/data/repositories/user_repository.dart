import 'package:gap/clean_architecture_structure/core/data/data_sources/central_system/central_system_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/user_model.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/user.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/user_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';

class UserRepositoryImpl implements UserRepository{

  final NetworkInfo networkInfo;
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final CentralSystemLocalDataSource centralSystemLocalDataSource;

  UserRepositoryImpl({
    @required this.networkInfo, 
    @required this.remoteDataSource, 
    @required this.localDataSource,
    @required this.centralSystemLocalDataSource
  });

  @override
  Future<Either<Failure, void>> login(User user)async{
    return await _executeFunction(()async{
      if( await networkInfo.isConnected() ){
        UserModel userModel = UserModel(email: user.email, password: user.password);
        final String accessToken = await remoteDataSource.login(userModel);
        await localDataSource.setUserInformation(userModel);
        await localDataSource.setAccessToken(accessToken);
        return Right(null);
      }else{
        return Left(ServerFailure(message: 'No hay conexión', type: ServerFailureType.LOGIN));
      }
    });
  }

  @override
  Future<Either<Failure, void>> reLogin()async{
    return await _executeFunction(()async{
      if( await networkInfo.isConnected() ){
        final UserModel user = await localDataSource.getUserInformation();
        if(_userFieldIsNotCorrect(user.email) || _userFieldIsNotCorrect(user.password))
          return Left(StorageFailure(excType: StorageExceptionType.NORMAL));
        final String accessToken = await remoteDataSource.login(user);
        await localDataSource.setAccessToken(accessToken);
      }
      return Right(null);
    });
  }

  bool _userFieldIsNotCorrect(String field){
    return [null, ''].contains(field);
  }

  @override
  Future<Either<Failure, void>> refreshAccessToken()async{
    return await _executeFunction(()async{
      if( await networkInfo.isConnected() ){
        final String oldAccessToken = await localDataSource.getAccessToken();
        final String newAccessToken = await remoteDataSource.refreshAccessToken(oldAccessToken);
        await localDataSource.setAccessToken(newAccessToken);
      }
      return Right(null);
    });
  }

  Future<Either<Failure, void>> _executeFunction(
    Future<Either<Failure, void>> Function() function
  )async{
    try{
      return await function();
    }on ServerException catch(exception){
      return Left(ServerFailure(message: exception.message, servExcType: exception.type));
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }

  @override
  Future<Either<Failure, void>> logout()async{
    try{
      await centralSystemLocalDataSource.removeAll();
      await centralSystemLocalDataSource.setAppRunnedAnyTime();
      return Right(null);
    }on StorageException catch(exception){
      return Left(StorageFailure(excType: exception.type));
    }
  }

  
}