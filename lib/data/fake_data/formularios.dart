part of 'fake_data.dart';

final DateTime nowTime = DateTime.now();
List<Formulario> formularios = [
  Formulario.fromJson({
    'id':0,
    'stage':'realizada',
    'name':'Formulario PAE 2021A',
    'date':nowTime.toString(),
    'fields':[]
  }),
  Formulario.fromJson({
    'id':1,
    'stage':'pendiente',
    'name':'Formulario Calidad',
    'date':nowTime.toString(),
    'fields':[]
  }),
  Formulario.fromJson({
    'id':2,
    'stage':'pendiente',
    'name':'Formulario infraestructuras',
    'date':nowTime.toString(),
    'fields':[]
  }),
];