import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage{
  
  Map<String, String> storage = {};

  @override
  Future<void> write({AndroidOptions aOptions, IOSOptions iOptions, String key, String value})async{
    storage[key] = value;
  }
  @override
  Future<String> read({AndroidOptions aOptions, IOSOptions iOptions, String key})async{
    return storage[key];
  }
  @override
  Future<void> delete({AndroidOptions aOptions, IOSOptions iOptions, String key})async{
    storage.remove(key);
  }
}