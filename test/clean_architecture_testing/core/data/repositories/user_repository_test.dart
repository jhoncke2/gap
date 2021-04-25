import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/user_repository.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockNetworkInfo extends Mock implements NetworkInfo{}
class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource{}
class MockUserLocalDataSource extends Mock implements UserLocalDataSource{}

UserRepositoryImpl repository;
MockNetworkInfo networkInfo;
MockUserRemoteDataSource remoteDataSource;
MockUserLocalDataSource localDataSource;

void main(){
  setUp((){
    localDataSource = MockUserLocalDataSource();
    remoteDataSource = MockUserRemoteDataSource();
    networkInfo = MockNetworkInfo();
    repository = UserRepositoryImpl(
      networkInfo: networkInfo,
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,      
    );
  });
}