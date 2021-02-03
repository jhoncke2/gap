import 'package:gap/logic/helpers/storage_saver.dart';

class MockStorageSaver extends StorageSaver{
  final Map<String, String> storage = {};

  @override
  Future<void> write(String key, String value)async{
    storage[key] = value;
  }

  @override
  Future<String> read(String key)async{
    return storage[key];
  }
  
  @override
  Future<void> delete(String key)async{
    storage.remove(key);
  }
}