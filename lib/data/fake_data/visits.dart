part of 'fake_data.dart';

final List<Visit> visits = [
  //Pendientes
  Visit.fromJson({
    'name': 'Colegio San Cristobal',
    'date':DateTime.now().toIso8601String(),
    'stage':'pendiente'
  }),
  Visit.fromJson({
    'name': 'Colegio La Merced',
    'date':DateTime.now().toIso8601String(),
    'stage':'pendiente'
  }),
  Visit.fromJson({
    'name': 'Colegio Maria Merced',
    'date':DateTime.now().add(Duration(days: 1)).toIso8601String(),
    'stage':'pendiente'
  }),
  Visit.fromJson({
    'name': 'Colegio La Providencia',
    'date':DateTime.now().add(Duration(days: 1)).toIso8601String(),
    'stage':'pendiente'
  }),
  //Realizadas
  Visit.fromJson({
    'name': 'Escuela Normal Superior',
    'date':DateTime.now().toIso8601String(),
    'stage':'realizada'
  }),
  Visit.fromJson({
    'name': 'Colegio El Americano',
    'date':DateTime.now().toIso8601String(),
    'stage':'realizada'
  }),
  Visit.fromJson({
    'name': 'Colegio Departamental',
    'date':DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
    'stage':'realizada'
  }),
  Visit.fromJson({
    'name': 'Colegio La Golondrina',
    'date':DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
    'stage':'realizada'
  }),
  Visit.fromJson({
    'name': 'Polideportivo San Antonio',
    'date':DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
    'stage':'realizada'
  }),
  
];