import 'package:gap/logic/models/entities/visit.dart';

final List<Visit> visits = [
  //Pendientes
  Visit.fromJson({
    'name': 'Colegio San Cristobal',
    'fecha':DateTime.now().toIso8601String(),
    'step':'pendiente'
  }),
  Visit.fromJson({
    'name': 'Colegio La Merced',
    'fecha':DateTime.now().toIso8601String(),
    'step':'pendiente'
  }),
  Visit.fromJson({
    'name': 'Colegio Maria Merced',
    'fecha':DateTime.now().add(Duration(days: 1)).toIso8601String(),
    'step':'pendiente'
  }),
  Visit.fromJson({
    'name': 'Colegio La Providencia',
    'fecha':DateTime.now().add(Duration(days: 1)).toIso8601String(),
    'step':'pendiente'
  }),
  //Realizadas
  Visit.fromJson({
    'name': 'Escuela Normal Superior',
    'fecha':DateTime.now().toIso8601String(),
    'step':'realizada'
  }),
  Visit.fromJson({
    'name': 'Colegio El Americano',
    'fecha':DateTime.now().toIso8601String(),
    'step':'realizada'
  }),
  Visit.fromJson({
    'name': 'Colegio Departamental',
    'fecha':DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
    'step':'realizada'
  }),
  Visit.fromJson({
    'name': 'Colegio La Golondrina',
    'fecha':DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
    'step':'realizada'
  }),
  Visit.fromJson({
    'name': 'Polideportivo San Antonio',
    'fecha':DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
    'step':'realizada'
  }),
  
];