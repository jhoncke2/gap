import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';

// ignore: must_be_immutable
class Muestra extends Equatable{
  final String tipo;
  final List<String> rangos;
  final List<Componente> componentes;
  int nMuestreos;

  Muestra({
    @required this.tipo,
    @required this.rangos,
    @required this.componentes,
    @required this.nMuestreos
  });

  @override
  List<Object> get props => [this.tipo, this.rangos, this.componentes, this.nMuestreos];
}