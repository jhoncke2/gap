import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class RangoToma extends Equatable{
  final String rango;
  final double pesoEsperado;
  final List<double> pesosTomados;

  RangoToma({
    @required this.rango, 
    @required this.pesoEsperado, 
    @required this.pesosTomados
  });

  @override
  List<Object> get props => [this.rango, this.pesoEsperado, this.pesosTomados];
}