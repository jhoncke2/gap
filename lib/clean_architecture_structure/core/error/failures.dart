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

class ServerFailure extends Failure{
  
}