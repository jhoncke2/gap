import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/commented_images/commented_images_remote_data_source.dart';

class MockStorageConnector extends Mock implements StorageConnector{}


CommentedImagesRemoteDataSourceImpl remoteDataSource;
MockStorageConnector storageConnector;

void main(){
  setUp((){
    storageConnector = MockStorageConnector();
    remoteDataSource = CommentedImagesRemoteDataSourceImpl(
      storageConnector: storageConnector
    );
  });
}