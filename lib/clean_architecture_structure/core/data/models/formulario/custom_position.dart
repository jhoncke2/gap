import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/custom_position.dart';

class CustomPositionModel extends CustomPosition{
  CustomPositionModel({
    @required double latitude,
    @required double longitude
  }):super(
    latitude: latitude,
    longitude: longitude
  );

  factory CustomPositionModel.fromJson(Map<String, dynamic> json)=>CustomPositionModel(
    latitude: (json['latitud'] as num).toDouble(),
    longitude: (json['longitud'] as num).toDouble()
  );

  factory CustomPositionModel.fromCustomPosition(CustomPosition position)=>CustomPositionModel(
    latitude: position.latitude,
    longitude: position.longitude
  );

  Map<String, dynamic> toJson()=>{
    'latitud':latitude,
    'longitud':longitude,
  };
}