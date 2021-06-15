import 'package:permission_handler/permission_handler.dart';

enum PlatformPermissionStatus{
  GRANTED,
  UNGRANTED
}

abstract class NativeServicesPermissions{
  Future<bool> get gpsIsGranted;
  Future<PlatformPermissionStatus> get gpsRequestStatus;
  Future<bool> get storageIsGranted;
  Future<PlatformPermissionStatus> get storageRequestStatus;
}

class NativeServicesPermissionsImpl implements NativeServicesPermissions{

  @override
  Future<bool> get gpsIsGranted => Permission.location.isGranted;

  @override
  Future<PlatformPermissionStatus> get gpsRequestStatus async => _convertPermissionStatus( await Permission.location.request() );

  @override
  Future<bool> get storageIsGranted => Permission.storage.isGranted;

  @override
  Future<PlatformPermissionStatus> get storageRequestStatus async => _convertPermissionStatus( await Permission.storage.request() );

  PlatformPermissionStatus _convertPermissionStatus(PermissionStatus status) => status.isGranted? 
    PlatformPermissionStatus.GRANTED 
    : PlatformPermissionStatus.UNGRANTED;
}