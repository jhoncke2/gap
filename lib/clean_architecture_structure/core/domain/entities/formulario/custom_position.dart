import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
class CustomPosition extends Equatable{
  final double latitude;
  final double longitude;

  CustomPosition({
    @required this.latitude, 
    @required this.longitude
  });

  @override
  List<Object> get props => [latitude, longitude];
}