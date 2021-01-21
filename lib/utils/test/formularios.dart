import 'package:gap/models/entities/formulario.dart';
final DateTime nowTime = DateTime.now();
List<Formulario> formularios = [
  Formulario.fromJson(json: {
    'id':0,
    'step':'realizada',
    'name':'Formulario PAE 2021A',
    'date':nowTime.toString(),
    'fields':[]
  }),
  Formulario.fromJson(json: {
    'id':1,
    'step':'pendiente',
    'name':'Formulario Calidad',
    'date':nowTime.toString(),
    'fields':[]
  }),
  Formulario.fromJson(json: {
    'id':2,
    'step':'pendiente',
    'name':'Formulario infraestructuras',
    'date':nowTime.toString(),
    'fields':[]
  }),
];