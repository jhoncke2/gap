import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';

// ignore: must_be_immutable
class Muestreo extends Equatable{
  
  final String tipo;
  final bool obligatorio;
  final List<String> rangos;
  final List<List<double>> pesosEsperadosPorRango;
  final List<Componente> componentes;
  final List<Muestra> muestrasTomadas;
  final int minMuestras;
  final int maxMuestras;
  int nMuestras;

  Muestreo({
    @required this.tipo,
    @required this.obligatorio,
    @required this.rangos,
    @required this.pesosEsperadosPorRango,
    @required this.componentes,
    @required this.muestrasTomadas,
    @required this.minMuestras,
    @required this.maxMuestras,    
    @required this.nMuestras
  });

  @override
  List<Object> get props => [this.tipo, this.obligatorio, this.rangos, this.pesosEsperadosPorRango, this.componentes, this.muestrasTomadas, this.nMuestras];
}