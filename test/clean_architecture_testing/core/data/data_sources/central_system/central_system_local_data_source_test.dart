import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/central_system/central_system_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';

class MockStorageConnector extends Mock implements StorageConnector{}

CentralSystemLocalDataSourceImpl localDataSource;
MockStorageConnector storageConnector;

void main(){
  setUp((){
    storageConnector = MockStorageConnector();
    localDataSource = CentralSystemLocalDataSourceImpl(
      storageConnector: storageConnector
    );
  });

  group('removeAll', (){
    test('should remove all successfuly', ()async{
      await localDataSource.removeAll();
      verify(storageConnector.removeAll());
    });
  });

  group('get app runned any time', (){
    test('should return true when apprunnedanytime is true in storage', ()async{
      when(storageConnector.getString(any)).thenAnswer((realInvocation) async => 'true');
      final bool anyTimeRunned = await localDataSource.getAppRunnedAnyTime();
      verify(storageConnector.getString(CentralSystemLocalDataSourceImpl.CENTRAL_SYSTEM_STORAGE_KEY));
      expect(anyTimeRunned, true);
    });

    test('should return false when apprunnedanytime is not true in storage', ()async{
      when(storageConnector.getString(any)).thenAnswer((realInvocation) async => '');
      final bool anyTimeRunned = await localDataSource.getAppRunnedAnyTime();
      verify(storageConnector.getString(CentralSystemLocalDataSourceImpl.CENTRAL_SYSTEM_STORAGE_KEY));
      expect(anyTimeRunned, false);
    });
  });

  group('set app runned any time', (){
    test('should set the appRunnedAnyTime successfuly', ()async{
      await localDataSource.setAppRunnedAnyTime();
      verify(storageConnector.setString('true', CentralSystemLocalDataSourceImpl.CENTRAL_SYSTEM_STORAGE_KEY));
    });
  });
}