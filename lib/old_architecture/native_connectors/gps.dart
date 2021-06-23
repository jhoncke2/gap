import 'package:geolocator/geolocator.dart';

class GPSOld{
  static Future<bool> get gpsIsEnabled async => await Geolocator.isLocationServiceEnabled();
  static Future<LocationPermission> get gpsPermission async => await Geolocator.checkPermission();
  static Function get openAppSettings => Geolocator.openAppSettings;
  static Function get openGpsSettings => Geolocator.openLocationSettings;
  static Future<Position> get gpsPosition async => await Geolocator.getCurrentPosition();
}