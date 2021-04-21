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
    @required this.type
  });
}

class ServerFailure extends Failure{
  
}