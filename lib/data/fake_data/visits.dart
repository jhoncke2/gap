part of 'fake_data.dart';

final List<OldVisit> visits = [
  //Pendientes
  OldVisit.fromJson({
    'id':0,
    'name': 'Colegio San Cristobal',
    'date':DateTime.now().toIso8601String(),
    'stage':'pendiente'
  }),
  OldVisit.fromJson({
    'id':1,
    'name': 'Colegio La Merced',
    'date':DateTime.now().toIso8601String(),
    'stage':'pendiente'
  }),
  OldVisit.fromJson({
    'id':2,
    'name': 'Colegio Maria Merced',
    'date':DateTime.now().add(Duration(days: 1)).toIso8601String(),
    'stage':'pendiente'
  }),
  OldVisit.fromJson({
    'id':3,
    'name': 'Colegio La Providencia',
    'date':DateTime.now().add(Duration(days: 1)).toIso8601String(),
    'stage':'pendiente'
  }),
  //Realizadas
  OldVisit.fromJson({
    'id':4,
    'name': 'Escuela Normal Superior',
    'date':DateTime.now().toIso8601String(),
    'stage':'realizada'
  }),
  OldVisit.fromJson({
    'id':5,
    'name': 'Colegio El Americano',
    'date':DateTime.now().toIso8601String(),
    'stage':'realizada'
  }),
  OldVisit.fromJson({
    'id':6,
    'name': 'Colegio Departamental',
    'date':DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
    'stage':'realizada'
  }),
  OldVisit.fromJson({
    'id':7,
    'name': 'Colegio La Golondrina',
    'date':DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
    'stage':'realizada'
  }),
  OldVisit.fromJson({
    'id':8,
    'name': 'Polideportivo San Antonio',
    'date':DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
    'stage':'realizada'
  }),
];