import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/visit.dart';

class Project extends Equatable{
  final int id;
  final String nombre;
  final List<Visit> visits;

  Project({
    this.id,
    this.nombre,
    this.visits,
  });

  @override
  List<Object> get props => [id, nombre, visits];
}