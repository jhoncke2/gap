import 'package:gap/models/formulario.dart';
List<Formulario> formularios = [
  Formulario.fromJson(json: {
    'id':0,
    'step':'realizada',
    'name':'Formulario PAE 2021A',
    'time':{
      'hour':12,
      'minute':50
    },
    'fields':[]
  }),
  Formulario.fromJson(json: {
    'id':1,
    'step':'pendiente',
    'name':'Formulario Calidad',
    'time':{
      'hour':12,
      'minute':50
    },
    'fields':[]
  }),
  Formulario.fromJson(json: {
    'id':2,
    'step':'pendiente',
    'name':'Formulario infraestructuras',
    'time':{
      'hour':13,
      'minute':35
    },
    'fields':[]
  }),
];