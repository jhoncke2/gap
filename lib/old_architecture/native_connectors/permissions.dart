import 'package:permission_handler/permission_handler.dart';

class NativeServicesPermissionsOld{

  static Future<bool> get gpsIsGranted async => await Permission.location.isGranted;
  static Future<PermissionStatus> get gpsServiceStatus async => await Permission.location.request();

  static get storageIsGranted async => await Permission.storage.isGranted;
  static Future<PermissionStatus> get storageServiceStatus async => await Permission.storage.request();
  
  static get openSettings  => openAppSettings;

}