import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/entity_with_stage.dart';

// ignore: must_be_immutable
class Visit extends EntityWithStage{
  final int id;
  final DateTime date;
  final bool completo;
  final Sede sede;
  final List<dynamic> formularios;
  
  Visit({
    @required this.id,
    @required this.date,
    @required this.completo,
    @required this.sede,
    @required this.formularios,
    ProcessStage stage
  }):super(
    name: (sede == null)? '' : sede.nombre,
    stage: stage?? completo? ProcessStage.Realizada : ProcessStage.Pendiente
  );

  @override
  List<Object> get props => [id, date.year, date.month, date.day, completo, sede, formularios];
}

class Sede extends Equatable{
  final int id;
  final String nombre;
  final String departamento;
  final String ciudad;
  final String direccion;
  final String telefono;
  final String barrio;

  Sede({
    this.id,
    this.nombre,
    this.departamento,
    this.ciudad,
    this.direccion,
    this.telefono,
    this.barrio,
  });

  @override
  List<Object> get props => [id, nombre, departamento, ciudad, direccion, telefono, barrio];
}