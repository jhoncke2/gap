import 'package:meta/meta.dart';

enum StorageExceptionType{
  PLATFORM,
  NORMAL
}

class StorageException implements Exception{
  final StorageExceptionType type;

  StorageException({@required this.type});
}

class ServerException implements Exception{
}