import 'package:meta/meta.dart';

enum StorageExceptionType{
  PLATFORM,
  NORMAL
}

class StorageException implements Exception{
  final StorageExceptionType type;

  StorageException({@required this.type});
}

enum ServerExceptionType{
  LOGIN,
  REFRESH_ACCESS_TOKEN,
  NORMAL
}

class ServerException implements Exception{
  final String message;
  final ServerExceptionType type;

  ServerException({
    this.message,
    this.type
  });
}