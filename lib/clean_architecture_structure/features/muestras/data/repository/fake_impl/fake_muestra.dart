import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/componente_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestreo_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/rango_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';

Formulario fakePreFormulario = FormularioModel(
  id: 1,
  nombre: 'Pre formulario',
  completo: false,
  initialDate: DateTime.now(),
  campos: customFormFieldsFromJson([
    {
        "type": "number",
        "required": false,
        "label": "NUMERO DE ORDEN DE SERVICIO",
        "className": "form-control",
        "value":"4",
        "name": "number-1586211811903",
        "access": false
    },
    {
        "type": "select",
        "required": false,
        "label": "CLIENTE",
        "className": "form-control",
        "name": "select-1586202480938",
        "access": false,
        "multiple": false,
        "values": [
            {
                "label": "ACCIONA AGUA",
                "value": "ACCIONA AGUA",
                "selected": true
            },
            {
                "label": "ALIANZA COLOMBO FRANCESA ",
                "value": "ALIANZA COLOMBO FRANCESA "
            }
        ]
    },
    {
        "type": "text",
        "required": false,
        "label": "Otro",
        "description": "Cliente",
        "className": "form-control",
        "name": "text-1618235283610",
        "access": false,
        "subtype": "text",
        "value":"texto"
    },
    {
        "type": "checkbox-group",
        "required": false,
        "label": "SERVICIO REALIZADO",
        "toggle": false,
        "inline": false,
        "name": "checkbox-group-1618234129444",
        "access": false,
        "other": false,
        "values": [
            {
                "label": "REVISIÓN DE EQUIPO",
                "value": "REVISIÓN DE EQUIPO",
                "selected":true
            },
            {
                "label": "MANTENIMIENTO DE EQUIPO",
                "value": "MANTENIMIENTO DE EQUIPO",
                "selected":true
            }
        ]
    }
  ])
);

Formulario fakePosFormulario = FormularioModel(
  id: 2,
  nombre: 'Pos formulario',
  completo: false,
  initialDate: DateTime.now(),
  campos: customFormFieldsFromJson([
    {
        "type": "number",
        "required": false,
        "label": "NUMERO DE ORDEN DE SERVICIO 1",
        "className": "form-control",
        "value":"4",
        "name": "number-1586211811903",
        "access": false
    },
    {
        "type": "number",
        "required": false,
        "label": "NUMERO DE SERVICIO DEL ORDEN",
        "className": "form-control",
        "value":"4",
        "name": "number-15862118102589",
        "access": false
    },
    {
        "type": "select",
        "required": false,
        "label": "CLIENTE",
        "className": "form-control",
        "name": "select-1586202480938",
        "access": false,
        "multiple": false,
        "values": [
            {
                "label": "ACCIONA AGUA",
                "value": "ACCIONA AGUA",
                "selected": true
            },
            {
                "label": "ALIANZA COLOMBO FRANCESA ",
                "value": "ALIANZA COLOMBO FRANCESA "
            }
        ]
    },
    {
        "type": "text",
        "required": false,
        "label": "Otro",
        "description": "Cliente",
        "className": "form-control",
        "name": "text-1618235283610",
        "access": false,
        "subtype": "text",
        "value":"texto"
    },
    {
        "type": "checkbox-group",
        "required": false,
        "label": "SERVICIO REALIZADO",
        "toggle": false,
        "inline": false,
        "name": "checkbox-group-1618234129444",
        "access": false,
        "other": false,
        "values": [
            {
                "label": "REVISIÓN DE EQUIPO",
                "value": "REVISIÓN DE EQUIPO",
                "selected":true
            },
            {
                "label": "MANTENIMIENTO DE EQUIPO",
                "value": "MANTENIMIENTO DE EQUIPO",
                "selected":true
            }
        ]
    },
    {
        "type": "text",
        "required": false,
        "label": "otro texto",
        "description": "Cliente",
        "className": "form-control",
        "name": "text-1618235283610",
        "access": false,
        "subtype": "text",
        "value":"texto"
    },
  ])
);

Muestreo fakeMuestreo = MuestreoModel(
  id: 1,
  tipo: 'Almuerzo',
  obligatorio: true,
  rangos: [
    RangoModel(id: 1, nombre: '5-8 años', pesosEsperados: [20.0, 40.0, 100.0], completo: false),
    RangoModel(id: 2, nombre: '9-12 años', pesosEsperados: [30.0, 65.0, 125.0], completo: false)
  ],
  stringRangos: ['5-8 años', '9-12 años'], 
  componentes: [
    ComponenteModel(
      nombre: 'Lácteos',
      preparacion: null
    ),
    ComponenteModel(
      nombre: 'Cereales',
      preparacion: null
    ),
    ComponenteModel(
      nombre: 'Protéicos',
      preparacion: null,
    ),
  ],
  muestrasTomadas: [
    
  ],
  minMuestras: 1,
  maxMuestras: 3,
  nMuestras: 0,
  preFormulario: fakePreFormulario,
  posFormulario: fakePosFormulario,
);