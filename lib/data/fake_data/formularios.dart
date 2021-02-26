part of 'fake_data.dart';

final DateTime nowTime = DateTime.now();
List<Formulario> formularios = [
  Formulario.fromJson(formAtFormFieldsFillingOut),
  Formulario.fromJson(formAtFirstFirmerFillingOut),
  Formulario.fromJson(formAtSecondaryFirmersFillingOut),
  Formulario.fromJson({
    'formulario_pivot_id':3,
    'completo':true,
    'nombre':'Formulario Profesorado',
    'date':nowTime.toString(),
    'fecha':'2021-02-29',
    'fields':[],
    'firmers':[]
  }),
  Formulario.fromJson({
    'formulario_pivot_id':4,
    'completo':false,
    'nombre':'Formulario Exportación',
    'date':nowTime.toString(),
    'fecha':'2021-02-29',
    'fields':[],
    'firmers':[]
  }),
  Formulario.fromJson({
    'formulario_pivot_id':5,
    'completo':false,
    'nombre':'Formulario proyectos',
    'date':nowTime.toString(),
    'fecha':'2021-02-29',
    'fields':[],
    'firmers':[]
  }),
  Formulario.fromJson({
    'formulario_pivot_id':6,
    'completo':true,
    'nombre':'Formulario Permutaciones',
    'date':nowTime.toString(),
    'fecha':'2021-02-29',
    'fields':[],
    'firmers':[]
  }),
  Formulario.fromJson({
    'formulario_pivot_id':7,
    'completo':false,
    'nombre':'Formulario Transporte',
    'date':nowTime.toString(),
    'fecha':'2021-02-29',
    'fields':[],
    'firmers':[]
  }),
  Formulario.fromJson({
    'formulario_pivot_id':8,
    'completo':false,
    'nombre':'Formulario inmobiliarias',
    'date':nowTime.toString(),
    'fecha':'2021-02-29',
    'fields':[],
    'firmers':[]
  }),
  Formulario.fromJson({
    'formulario_pivot_id':9,
    'completo':true,
    'nombre':'Formulario PAE 2021C',
    'date':nowTime.toString(),
    'fecha':'2021-02-29',
    'fields':[],
    'firmers':[]
  }),
  Formulario.fromJson({
    'formulario_pivot_id':10,
    'completo':false,
    'nombre':'Formulario Pavimentación',
    'date':nowTime.toString(),
    'fecha':'2021-02-29',
    'fields':[],
    'firmers':[]
  }),
  Formulario.fromJson({
    'formulario_pivot_id':11,
    'completo':false,
    'nombre':'Formulario localidades',
    'date':nowTime.toString(),
    'fecha':'2021-02-29',
    'fields':[],
    'firmers':[]
  }),
  Formulario.fromJson({
    'formulario_pivot_id':12,
    'completo':true,
    'nombre':'Formulario PAE 2021D',
    'date':nowTime.toString(),
    'fecha':'2021-02-29',
    'fields':[],
    'firmers':[]
  }),
  Formulario.fromJson({
    'formulario_pivot_id':13,
    'completo':false,
    'nombre':'Formulario Producción',
    'date':nowTime.toString(),
    'fecha':'2021-02-29',
    'fields':[],
    'firmers':[]
  }),
  Formulario.fromJson({
    'formulario_pivot_id':14,
    'completo':false,
    'nombre':'Formulario demandas',
    'date':nowTime.toString(),
    'fecha':'2021-02-29',
    'fields':[],
    'firmers':[]
  }),
  Formulario.fromJson({
    'formulario_pivot_id':15,
    'completo':true,
    'nombre':'Formulario PAE 2021E',
    'date':nowTime.toString(),
    'fecha':'2021-02-29',
    'fields':[],
    'firmers':[]
  }),
  Formulario.fromJson({
    'formulario_pivot_id':16,
    'completo':false,
    'nombre':'Formulario Trabajadores',
    'date':nowTime.toString(),
    'fecha':'2021-02-29',
    'fields':[],
    'firmers':[]
  }),
  Formulario.fromJson({
    'formulario_pivot_id':17,
    'completo':false,
    'nombre':'Formulario administración',
    'date':nowTime.toString(),
    'fecha':'2021-02-29',
    'fields':[],
    'firmers':[]
  }),
];

final Map<String, dynamic> formAtFormFieldsFillingOut = {
  'formulario_pivot_id':0,
  'completo':true,
  'nombre':'Formulario PAE 2021A',
  'date':nowTime.toString(),
  'fecha':'2021-02-29',
  'fields':[
    {
      'formulario_pivot_id':0,
      'nombre':'f1',
      'type':'input',
      'is_filled':true,
      'value':'parangaricutirimicuaro'
    },
    {
      'formulario_pivot_id':1,
      'nombre':'f2',
      'type':'input',
      'is_filled':false,
      'value':'parangaricutirimicuaro'
    }
  ],
  'firmers':[]
};

final Map<String, dynamic> formAtFirstFirmerFillingOut = {
  'formulario_pivot_id':1,
  'completo':false,
  'nombre':'Formulario Calidad',
  'date':nowTime.toString(),
  'fecha':'2021-02-29',
  'fields':[
    {
      'formulario_pivot_id':2,
      'nombre':'f1',
      'type':'input',
      'is_filled':true,
      'value':'parangaricutirimicuaro'
    },
    {
      'formulario_pivot_id':3,
      'nombre':'f2',
      'type':'input',
      'is_filled':true,
      'value':'parangaricutirimicuaro'
    }
  ],
  'firmers':[]
};

final Map<String, dynamic> formAtSecondaryFirmersFillingOut = {
  'formulario_pivot_id':2,
  'completo':false,
  'nombre':'Formulario infraestructuras',
  'date':nowTime.toString(),
  'fecha':'2021-02-29',
  'fields':[
    {
      'formulario_pivot_id':2,
      'nombre':'f1',
      'type':'input',
      'is_filled':true,
      'value':'parangaricutirimicuaro'
    }
  ],
  'firmers':[
    {
      'formulario_pivot_id':0,
      'nombre':'Firmer1',
      'identif_document_type':'CC',
      'identif_Document_number':12345,
      'firm':File('assets/logos/logo_con_fondo.png').toString()      
    }
  ]
};