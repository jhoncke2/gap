part of 'fake_data.dart';



final DateTime nowTime = DateTime.now();
List<OldFormulario> formularios = [
  OldFormulario.fromJson(formAtFormFieldsFillingOut),
  OldFormulario.fromJson(formAtFirstFirmerFillingOut),
  OldFormulario.fromJson(formAtSecondaryFirmersFillingOut),
  OldFormulario.fromJson({
    'id':3,
    'stage':'realizada',
    'name':'Formulario Profesorado',
    'date':nowTime.toString(),
    'fields':[],
    'firmers':[]
  }),
  OldFormulario.fromJson({
    'id':4,
    'stage':'pendiente',
    'name':'Formulario Exportación',
    'date':nowTime.toString(),
    'fields':[],
    'firmers':[]
  }),
  OldFormulario.fromJson({
    'id':5,
    'stage':'pendiente',
    'name':'Formulario proyectos',
    'date':nowTime.toString(),
    'fields':[],
    'firmers':[]
  }),
  OldFormulario.fromJson({
    'id':6,
    'stage':'realizada',
    'name':'Formulario Permutaciones',
    'date':nowTime.toString(),
    'fields':[],
    'firmers':[]
  }),
  OldFormulario.fromJson({
    'id':7,
    'stage':'pendiente',
    'name':'Formulario Transporte',
    'date':nowTime.toString(),
    'fields':[],
    'firmers':[]
  }),
  OldFormulario.fromJson({
    'id':8,
    'stage':'pendiente',
    'name':'Formulario inmobiliarias',
    'date':nowTime.toString(),
    'fields':[],
    'firmers':[]
  }),
  OldFormulario.fromJson({
    'id':9,
    'stage':'realizada',
    'name':'Formulario PAE 2021C',
    'date':nowTime.toString(),
    'fields':[],
    'firmers':[]
  }),
  OldFormulario.fromJson({
    'id':10,
    'stage':'pendiente',
    'name':'Formulario Pavimentación',
    'date':nowTime.toString(),
    'fields':[],
    'firmers':[]
  }),
  OldFormulario.fromJson({
    'id':11,
    'stage':'pendiente',
    'name':'Formulario localidades',
    'date':nowTime.toString(),
    'fields':[],
    'firmers':[]
  }),
  OldFormulario.fromJson({
    'id':12,
    'stage':'realizada',
    'name':'Formulario PAE 2021D',
    'date':nowTime.toString(),
    'fields':[],
    'firmers':[]
  }),
  OldFormulario.fromJson({
    'id':13,
    'stage':'pendiente',
    'name':'Formulario Producción',
    'date':nowTime.toString(),
    'fields':[],
    'firmers':[]
  }),
  OldFormulario.fromJson({
    'id':14,
    'stage':'pendiente',
    'name':'Formulario demandas',
    'date':nowTime.toString(),
    'fields':[],
    'firmers':[]
  }),
  OldFormulario.fromJson({
    'id':15,
    'stage':'realizada',
    'name':'Formulario PAE 2021E',
    'date':nowTime.toString(),
    'fields':[],
    'firmers':[]
  }),
  OldFormulario.fromJson({
    'id':16,
    'stage':'pendiente',
    'name':'Formulario Trabajadores',
    'date':nowTime.toString(),
    'fields':[],
    'firmers':[]
  }),
  OldFormulario.fromJson({
    'id':17,
    'stage':'pendiente',
    'name':'Formulario administración',
    'date':nowTime.toString(),
    'fields':[],
    'firmers':[]
  }),
];

final Map<String, dynamic> formAtFormFieldsFillingOut = {
  'id':0,
  'stage':'realizada',
  'name':'Formulario PAE 2021A',
  'date':nowTime.toString(),
  'fields':[
    {
      'id':0,
      'name':'f1',
      'type':'input',
      'is_filled':true,
      'value':'parangaricutirimicuaro'
    },
    {
      'id':1,
      'name':'f2',
      'type':'input',
      'is_filled':false,
      'value':'parangaricutirimicuaro'
    }
  ],
  'firmers':[]
};

final Map<String, dynamic> formAtFirstFirmerFillingOut = {
  'id':1,
  'stage':'pendiente',
  'name':'Formulario Calidad',
  'date':nowTime.toString(),
  'fields':[
    {
      'id':2,
      'name':'f1',
      'type':'input',
      'is_filled':true,
      'value':'parangaricutirimicuaro'
    },
    {
      'id':3,
      'name':'f2',
      'type':'input',
      'is_filled':true,
      'value':'parangaricutirimicuaro'
    }
  ],
  'firmers':[]
};

final Map<String, dynamic> formAtSecondaryFirmersFillingOut = {
  'id':2,
  'stage':'pendiente',
  'name':'Formulario infraestructuras',
  'date':nowTime.toString(),
  'fields':[
    {
      'id':2,
      'name':'f1',
      'type':'input',
      'is_filled':true,
      'value':'parangaricutirimicuaro'
    }
  ],
  'firmers':[
    {
      'id':0,
      'name':'Firmer1',
      'identif_document_type':'CC',
      'identif_Document_number':12345,
      'firm':File('assets/logos/logo_con_fondo.png').toString()      
    }
  ]
};