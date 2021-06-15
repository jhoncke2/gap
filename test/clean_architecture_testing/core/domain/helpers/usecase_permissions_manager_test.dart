import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/usecase_permissions_manager.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/platform/native_services_permission.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ClassX{
  Future<Either<Failure, bool>> functionX() async => Right(true);
}

class MockClassX extends Mock implements ClassX{}
class MockNativeServicesPermissions extends Mock implements NativeServicesPermissions{}

MockClassX mockClassX;
UseCasePermissionsManagerImpl manager;
MockNativeServicesPermissions permissions;

void main(){
  setUp((){
    mockClassX = MockClassX();

    permissions = MockNativeServicesPermissions();
    manager = UseCasePermissionsManagerImpl(
      permissions: permissions
    );
  });

  group('location permission', (){
    test('should execute the specified functions when there is location permission', ()async{
      when(permissions.gpsIsGranted).thenAnswer((_) async => true);
      await manager.executeFunctionByValidateLocation<bool>(mockClassX.functionX);
      verify(mockClassX.functionX());
    });

    test('should return the function returns when there is location permission', ()async{
      when(permissions.gpsIsGranted).thenAnswer((_) async => true);
      final result = await manager.executeFunctionByValidateLocation<bool>(mockClassX.functionX);
      expect(result, await mockClassX.functionX());
    });

    test('''should execute the specified functions when there is Not location permission
    and request status returns Granted''', ()async{
      when(permissions.gpsIsGranted).thenAnswer((_) async => false);
      when(permissions.gpsRequestStatus).thenAnswer((_) async => PlatformPermissionStatus.GRANTED);
      await manager.executeFunctionByValidateLocation<bool>(mockClassX.functionX);
      verify(permissions.gpsRequestStatus);
      verify(mockClassX.functionX());
    });

    test('''should return the function returns when there is Not location permission
    and request status returns Granted''', ()async{
      when(permissions.gpsIsGranted).thenAnswer((_) async => false);
      when(permissions.gpsRequestStatus).thenAnswer((_) async => PlatformPermissionStatus.GRANTED);
      final result = await manager.executeFunctionByValidateLocation<bool>(mockClassX.functionX);
      expect(result, await mockClassX.functionX());
    });

    test('''should execute the specified functions when there is Not location permission
    and request status returns Granted''', ()async{
      when(permissions.gpsIsGranted).thenAnswer((_) async => false);
      when(permissions.gpsRequestStatus).thenAnswer((_) async => PlatformPermissionStatus.UNGRANTED);
      await manager.executeFunctionByValidateLocation<bool>(mockClassX.functionX);
      verify(permissions.gpsRequestStatus);
      verifyNever(mockClassX.functionX());
    });

    test('''should return Left(UngrantedGPSFailure()) when there is Not location permission
    and request status returns Granted''', ()async{
      when(permissions.gpsIsGranted).thenAnswer((_) async => false);
      when(permissions.gpsRequestStatus).thenAnswer((_) async => PlatformPermissionStatus.UNGRANTED);
      final result = await manager.executeFunctionByValidateLocation<bool>(mockClassX.functionX);
      expect(result, Left(UngrantedGPSFailure()));
    });
  });

  group('storage permission', (){
    test('should execute the specified functions when there is location permission', ()async{
      when(permissions.storageIsGranted).thenAnswer((_) async => true);
      await manager.executeFunctionByValidateStorage<bool>(mockClassX.functionX);
      verify(mockClassX.functionX());
    });

    test('should return the function returns when there is location permission', ()async{
      when(permissions.storageIsGranted).thenAnswer((_) async => true);
      final result = await manager.executeFunctionByValidateStorage<bool>(mockClassX.functionX);
      expect(result, await mockClassX.functionX());
    });

    test('''should execute the specified functions when there is Not location permission
    and request status returns Granted''', ()async{
      when(permissions.storageIsGranted).thenAnswer((_) async => false);
      when(permissions.storageRequestStatus).thenAnswer((_) async => PlatformPermissionStatus.GRANTED);
      await manager.executeFunctionByValidateStorage<bool>(mockClassX.functionX);
      verify(permissions.storageRequestStatus);
      verify(mockClassX.functionX());
    });

    test('''should return the function returns when there is Not location permission
    and request status returns Granted''', ()async{
      when(permissions.storageIsGranted).thenAnswer((_) async => false);
      when(permissions.storageRequestStatus).thenAnswer((_) async => PlatformPermissionStatus.GRANTED);
      final result = await manager.executeFunctionByValidateStorage<bool>(mockClassX.functionX);
      expect(result, await mockClassX.functionX());
    });

    test('''should execute the specified functions when there is Not location permission
    and request status returns Granted''', ()async{
      when(permissions.storageIsGranted).thenAnswer((_) async => false);
      when(permissions.storageRequestStatus).thenAnswer((_) async => PlatformPermissionStatus.UNGRANTED);
      await manager.executeFunctionByValidateStorage<bool>(mockClassX.functionX);
      verify(permissions.storageRequestStatus);
      verifyNever(mockClassX.functionX());
    });

    test('''should return Left(UngrantedGPSFailure()) when there is Not location permission
    and request status returns Granted''', ()async{
      when(permissions.storageIsGranted).thenAnswer((_) async => false);
      when(permissions.storageRequestStatus).thenAnswer((_) async => PlatformPermissionStatus.UNGRANTED);
      final result = await manager.executeFunctionByValidateStorage<bool>(mockClassX.functionX);
      expect(result, Left(UngrantedStorageFailure()));
    });
  });
}