import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';

abstract class CentralSystemLocalDataSource{
  Future<void> removeAll();
  Future<bool> getAppRunnedAnyTime();
  Future<void> setAppRunnedAnyTime();
}

class CentralSystemLocalDataSourceImpl implements CentralSystemLocalDataSource{
  static const CENTRAL_SYSTEM_STORAGE_KEY = 'central_system';
  final StorageConnector storageConnector;

  CentralSystemLocalDataSourceImpl({
    @required this.storageConnector
  });

  @override
  Future<void> removeAll()async{
    await storageConnector.removeAll(); 
  }

  @override
  Future<bool> getAppRunnedAnyTime()async{
    final stringRunnedAnyTime = await storageConnector.getString(CENTRAL_SYSTEM_STORAGE_KEY);
    return stringRunnedAnyTime.toLowerCase() == 'true';
  }

  @override
  Future<void> setAppRunnedAnyTime()async{
    await storageConnector.setString('true', CENTRAL_SYSTEM_STORAGE_KEY);
  }
}