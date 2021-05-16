import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/rango_toma.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Componente extends Equatable{
  final String nombre;
  String preparacion;

  Componente({
    @required this.nombre, 
    @required this.preparacion, 
  });

  @override
  List<Object> get props => [this.nombre, this.preparacion];
}