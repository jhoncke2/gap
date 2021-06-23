import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/custom_position.dart';
import 'package:geolocator/geolocator.dart';

abstract class CustomLocator{
  Future<CustomPosition> get gpsPosition;
}

class CustomLocatorImpl implements CustomLocator{
  @override
  Future<CustomPosition> get gpsPosition async{
    final Position p = await Geolocator.getCurrentPosition();
    return CustomPosition(latitude: p.latitude, longitude: p.longitude);
  }
}