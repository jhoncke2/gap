import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';

class Muestra extends Equatable{
  final String tipo;
  final List<String> rangos;
  final List<Componente> componentes;

  Muestra({
    @required this.tipo, 
    @required this.rangos, 
    @required this.componentes
  });

  @override
  List<Object> get props => [this.tipo, this.rangos, this.componentes];
}