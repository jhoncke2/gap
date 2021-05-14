import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class Muestra extends Equatable{
  final String rango;
  final List<double> pesos;

  Muestra({
    @required this.rango, 
    @required this.pesos
  });

  @override
  List<Object> get props => [this.rango, this.pesos];
}