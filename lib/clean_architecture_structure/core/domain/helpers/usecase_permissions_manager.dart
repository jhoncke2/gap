import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/platform/native_services_permission.dart';

abstract class UseCasePermissionsManager{
  Future<Either<Failure, B>> executeFunctionByValidateStorage<B>(Future<Either<Failure, B>> Function() function);
  Future<Either<Failure, B>> executeFunctionByValidateLocation<B>(Future<Either<Failure, B>> Function() function);
}

class UseCasePermissionsManagerImpl implements UseCasePermissionsManager{
  final NativeServicesPermissions permissions;
  UseCasePermissionsManagerImpl({
    @required this.permissions
  });

  @override
  Future<Either<Failure, B>> executeFunctionByValidateLocation<B>(Future<Either<Failure, B>> Function() function)async{
    if( await _gpsIsFinallyGranted() )
      return await function();
    else
      return Left(UngrantedGPSFailure());
    
  }

  Future<bool> _gpsIsFinallyGranted()async{
    return await permissions.gpsIsGranted || await permissions.gpsRequestStatus == PlatformPermissionStatus.GRANTED;
  }

  @override
  Future<Either<Failure, B>> executeFunctionByValidateStorage<B>(Future<Either<Failure, B>> Function() function)async{
    if( await _storageIsFinallyGranted() )
      return await function();
    else
      return Left(UngrantedStorageFailure());
  }

  Future<bool> _storageIsFinallyGranted()async{
    return await permissions.storageIsGranted || await permissions.storageRequestStatus == PlatformPermissionStatus.GRANTED;
  }
}