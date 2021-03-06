import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final List properties;

  Failure({
    @required this.properties
  });
  
  @override
  List<Object> get props => properties;
}

enum StorageFailureType{
  PLATFORM,
  NORMAL
}

class StorageFailure extends Failure{
  final StorageFailureType type;

  StorageFailure({
    @required StorageExceptionType excType
  }):
    this.type = excType == StorageExceptionType.PLATFORM? StorageFailureType.PLATFORM : StorageFailureType.NORMAL
  ;
}

enum ServerFailureType{
  LOGIN,
  UNHAUTORAIZED,
  NORMAL
}

class ServerFailure extends Failure{
  final String message;
  final ServerFailureType type;

  ServerFailure({
    this.message,
    ServerFailureType type,
    ServerExceptionType servExcType,
  }):
    this.type = (type!=null)? type : 
    (servExcType==ServerExceptionType.LOGIN)? ServerFailureType.LOGIN :
    (servExcType==ServerExceptionType.UNHAUTORAIZED)? ServerFailureType.UNHAUTORAIZED : 
      ServerFailureType.NORMAL,
    super(
      properties: [message, (type??servExcType)]
    )
  ;
}

class InvalidInputFailure extends Failure{}

class FormatFailure extends Failure{}

class UngrantedStorageFailure extends Failure{}

class UngrantedGPSFailure extends Failure{}