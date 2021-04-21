part of 'fake_data.dart';

final List<VisitOld> visits = [
  //Pendientes
  VisitOld.fromJson({
    'id':0,
    'nombre': 'Colegio San Cristobal',
    'fecha': _transformDateInToString( DateTime.now() ),
    'stage':'pendiente',
    'completo':false,
    "sede": {
        "id": 1,
        "nombre": "Colegio San Cristobal",
        "departamento": "Sucre",
        "ciudad": "Tolú",
        "direccion": "5",
        "telefono": "310452",
        "barrio": "el rosario"
    },
    "formularios":[]
  }),
  VisitOld.fromJson({
    'id':1,
    'nombre': 'Colegio La Merced',
    'fecha': _transformDateInToString( DateTime.now() ),
    'stage':'pendiente',
    'completo':false,
    "sede": {
        "id": 1,
        "nombre": "Colegio La Merced",
        "departamento": "Sucre",
        "ciudad": "Tolú",
        "direccion": "5",
        "telefono": "310452",
        "barrio": "el rosario"
    },
    "formularios":[] 
  }),
  VisitOld.fromJson({
    'id':2,
    'nombre': 'Colegio Maria Merced',
    'fecha': _transformDateInToString( DateTime.now().add(Duration(days: 1)) ),
    'stage':'pendiente',
    'completo':false,
    "sede": {
        "id": 1,
        "nombre": "Colegio Maria Merced",
        "departamento": "Sucre",
        "ciudad": "Tolú",
        "direccion": "5",
        "telefono": "310452",
        "barrio": "el rosario"
    },
    "formularios":[] 
  }),
  VisitOld.fromJson({
    'id':3,
    'nombre': 'Colegio La Providencia',
    'fecha': _transformDateInToString( DateTime.now().add(Duration(days: 1)) ),
    'stage':'pendiente',
    'completo':false,
    "sede": {
        "id": 1,
        "nombre": "Colegio La Providencia",
        "departamento": "Sucre",
        "ciudad": "Tolú",
        "direccion": "5",
        "telefono": "310452",
        "barrio": "el rosario"
    },
    "formularios":[]
  }),
  //Realizadas
  VisitOld.fromJson({
    'id':4,
    'nombre': 'Escuela Normal Superior',
    'fecha': _transformDateInToString( DateTime.now() ),
    'stage':'realizada',
    'completo':false,
    "sede": {
        "id": 1,
        "nombre": "Escuela Normal Superior",
        "departamento": "Sucre",
        "ciudad": "Tolú",
        "direccion": "5",
        "telefono": "310452",
        "barrio": "el rosario"
    },
    "formularios":[]
  }),
  VisitOld.fromJson({
    'id':5,
    'nombre': 'Colegio El Americano',
    'fecha': _transformDateInToString( DateTime.now() ),
    'stage':'realizada',
    'completo':true,
    "sede": {
        "id": 1,
        "nombre": "Colegio El Americano",
        "departamento": "Sucre",
        "ciudad": "Tolú",
        "direccion": "5",
        "telefono": "310452",
        "barrio": "el rosario"
    },
    "formularios":[]
  }),
  VisitOld.fromJson({
    'id':6,
    'nombre': 'Colegio Departamental',
    'fecha': _transformDateInToString( DateTime.now().subtract(Duration(days: 1)) ),
    'stage':'realizada',
    'completo':true,
    "sede": {
        "id": 1,
        "nombre": "Colegio Departamental",
        "departamento": "Sucre",
        "ciudad": "Tolú",
        "direccion": "5",
        "telefono": "310452",
        "barrio": "el rosario"
    },
    "formularios":[]
  }),
  VisitOld.fromJson({
    'id':7,
    'nombre': 'Colegio La Golondrina',
    'fecha': _transformDateInToString( DateTime.now().subtract(Duration(days: 2)) ),
    'stage':'realizada',
    'completo':true,
    "sede": {
        "id": 1,
        "nombre": "Colegio La Golondrina",
        "departamento": "Sucre",
        "ciudad": "Tolú",
        "direccion": "5",
        "telefono": "310452",
        "barrio": "el rosario"
    },
    "formularios":[]
  }),
  VisitOld.fromJson({
    'id':8,
    'nombre': 'Polideportivo San Antonio',
    'fecha': _transformDateInToString( DateTime.now().subtract(Duration(days: 2)) ),
    'stage':'realizada',
    'completo':true,
    "sede": {
        "id": 1,
        "nombre": "Polideportivo San Antonio",
        "departamento": "Sucre",
        "ciudad": "Tolú",
        "direccion": "5",
        "telefono": "310452",
        "barrio": "el rosario"
    },
    "formularios":[]
  }),
];

String _transformDateInToString(DateTime date){
  return '${date.year}-${date.month}-${date.day}';
}
