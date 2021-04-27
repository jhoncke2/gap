import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/user_model.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/user_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';
import '../../../fixtures/fixture_reader.dart';

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

  group('login', (){
    String tAccessToken;
    UserModel tUser;

    setUp((){
      tAccessToken = 'access_token';
      tUser = _getUserFromFixtures();
    });

    test('''should login in the remoteDataSource, save the userInfo and the accessToken on the storage if all goes good, 
    and there is connectivity''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(remoteDataSource.login(any)).thenAnswer((_) async => tAccessToken);
      await repository.login(tUser);
      verify(networkInfo.isConnected());
      verify(remoteDataSource.login(tUser));
      verify(localDataSource.setUserInformation(tUser));
      verify(localDataSource.setAccessToken(tAccessToken));
    });

    test('''should not login in the remoteDataSource, not save the userInfo and the accessToken on the storage if all goes good, 
    and there is not connectivity''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      await repository.login(tUser);
      verifyNever(remoteDataSource.login(any));
      verifyNever(localDataSource.setUserInformation(any));
      verifyNever(localDataSource.setAccessToken(any));
    });

    test('''should return Right(null) there is connectivity and all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(remoteDataSource.login(any)).thenAnswer((_) async => tAccessToken);
      final result = await repository.login(tUser);
      expect(result, Right(null));
    });

    test('''should return Left(ServerFailure(Login)) when there is connectivity and remoteDataSource throws ServerException(Login)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(remoteDataSource.login(any)).thenThrow(ServerException(message: 'Credenciales inválidas', type: ServerExceptionType.LOGIN));
      final result = await repository.login(tUser);
      expect(result, Left(ServerFailure(message: 'Credenciales inválidas', servExcType: ServerExceptionType.LOGIN)));
    });

    test('''should return Left(ServerFailure(Login)) when there is not connectivity''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      final result = await repository.login(tUser);
      expect(result, Left(ServerFailure(message: 'No hay conexión', type: ServerFailureType.LOGIN)));
    });

    test('''Should return Left(StorageFailure(X)) when there is connectivity 
    and localDataSource throws a StorageException(X)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(remoteDataSource.login(any)).thenAnswer((_) async => tAccessToken);
      when(localDataSource.setUserInformation(any)).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));

      final result = await repository.login(tUser);
      expect(result, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });
  });

  group('reLogin', (){
    String tAccessToken;
    UserModel tUser;
    setUp((){
      tAccessToken = 'access_token';
      tUser = _getUserFromFixtures();
    });

    test('''should relogin, obtaining the user from the localDataSource, 
    loggining on the remoteDataSource, when there is connectivity''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_)async=>true);
      when(localDataSource.getUserInformation()).thenAnswer((_) async => tUser);
      when(remoteDataSource.login(any)).thenAnswer((_) async => tAccessToken);
      await repository.reLogin();
      verify(networkInfo.isConnected());
      verify(localDataSource.getUserInformation());
      verify(remoteDataSource.login(tUser));
      verify(localDataSource.setAccessToken(tAccessToken));
    });

    test('''should return Right(null) when all goes good and there is connectivity.''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_)async=>true);
      when(localDataSource.getUserInformation()).thenAnswer((_) async => tUser);
      when(remoteDataSource.login(any)).thenAnswer((_) async => tAccessToken);
      final result = await repository.reLogin();
      expect(result, Right(null));
    });

    test('''should neither login in the remoteDataSource, nor save the userInfo and the accessToken on the storage if all goes good, 
    and there is not connectivity''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      await repository.reLogin();
      verifyNever(localDataSource.getUserInformation());
      verifyNever(remoteDataSource.login(any));
      verifyNever(localDataSource.setAccessToken(any));
    });

    test('''should return Right(null) when all goes good and there is not connectivity.''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_)async=>false);
      when(localDataSource.getUserInformation()).thenAnswer((_) async => tUser);
      final result = await repository.reLogin();
      expect(result, Right(null));
    });

    test('''should return Left(ServerFailure(Login)) when there is connectivity and remoteDataSource throws ServerException(Login)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(localDataSource.getUserInformation()).thenAnswer((_) async => tUser);
      when(remoteDataSource.login(any)).thenThrow(ServerException(message: 'Credenciales inválidas', type: ServerExceptionType.LOGIN));
      final result = await repository.reLogin();
      expect(result, Left(ServerFailure(message: 'Credenciales inválidas', servExcType: ServerExceptionType.LOGIN)));
    });
    
    test('''Should return Left(StorageFailure(X)) when there is connectivity 
    and localDataSource throws a StorageException(X)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(localDataSource.getUserInformation()).thenAnswer((_) async => tUser);
      when(remoteDataSource.login(any)).thenAnswer((_) async => tAccessToken);
      when(localDataSource.setAccessToken(any)).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));

      final result = await repository.reLogin();
      expect(result, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });

    test('''should return Left(StorageFailure(X)) when there is connectivity and user info is uncompleted''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(localDataSource.getUserInformation()).thenAnswer((_) async => UserModel(email:null, password: ''));
      when(remoteDataSource.login(any)).thenAnswer((_) async => tAccessToken);
      final result = await repository.reLogin();
      expect(result, Left(StorageFailure(excType: StorageExceptionType.NORMAL)));
    });
  });

  group('refresh access token', (){
    String tOldAccessToken;
    String tNewAccessToken;
    setUp((){
      tOldAccessToken = 'old';
      tNewAccessToken = 'new';
    });

    test('''Should get the new Access Token from the remoteDataSource and save it on the localDataSource
    if there is connectivity''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(localDataSource.getAccessToken()).thenAnswer((_) async => tOldAccessToken);
      when(remoteDataSource.refreshAccessToken(any)).thenAnswer((_) async => tNewAccessToken);
      await repository.refreshAccessToken();
      verify(networkInfo.isConnected());
      verify(localDataSource.getAccessToken());
      verify(remoteDataSource.refreshAccessToken(tOldAccessToken));
      verify(localDataSource.setAccessToken(tNewAccessToken));
    });

    test('''Should not get the new Access Token from the remoteDataSource and not save anything on the localDataSource
    if there is not connectivity''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(localDataSource.getAccessToken()).thenAnswer((_) async => tOldAccessToken);
      when(remoteDataSource.refreshAccessToken(any)).thenAnswer((_) async => tNewAccessToken);
      await repository.refreshAccessToken();
      verifyNever(localDataSource.getAccessToken());
      verifyNever(remoteDataSource.refreshAccessToken(any));
      verifyNever(localDataSource.setAccessToken(any));
    });

    test('''Should return Right(null) when there is connectivity and all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(localDataSource.getAccessToken()).thenAnswer((_) async => tOldAccessToken);
      when(remoteDataSource.refreshAccessToken(any)).thenAnswer((_) async => tNewAccessToken);
      final result = await repository.refreshAccessToken();
      expect(result, Right(null));
    });

    test('''Should return Left(ServerFailure(ACCESS_TOKEN)) when there is connectivity 
    and remoteDataSource throws a ServerException(ACCESS_TOKEN)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(localDataSource.getAccessToken()).thenAnswer((_) async => tOldAccessToken);
      when(remoteDataSource.refreshAccessToken(any)).thenThrow(ServerException(type: ServerExceptionType.REFRESH_ACCESS_TOKEN));
      final result = await repository.refreshAccessToken();
      expect(result, Left(ServerFailure(servExcType: ServerExceptionType.REFRESH_ACCESS_TOKEN)));
    });

    test('''Should return Right(null) when there is not connectivity and all goes good''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      final result = await repository.refreshAccessToken();
      expect(result, Right(null));
    });

    test('''Should return Left(StorageFailure(X)) when there is connectivity 
    and localDataSource throws a StorageException(X)''', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(localDataSource.getAccessToken()).thenThrow(StorageException(type: StorageExceptionType.PLATFORM));
      when(remoteDataSource.refreshAccessToken(any)).thenAnswer((_) async => tNewAccessToken);
      final result = await repository.refreshAccessToken();
      expect(result, Left(StorageFailure(excType: StorageExceptionType.PLATFORM)));
    });
    
  });
}

UserModel _getUserFromFixtures(){
  final String stringUser = callFixture('user.json');
  final Map<String, dynamic> jsonUser = jsonDecode(stringUser);
  return UserModel.fromJson(jsonUser);
}