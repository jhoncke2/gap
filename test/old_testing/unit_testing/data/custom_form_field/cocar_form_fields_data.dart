import 'dart:convert';

List<Map> allData = []
..addAll(headersData)
..addAll(paragraphsData)
..addAll(textsData)
..addAll(textAreasData)
..addAll(numbersData)
..addAll(datesAndTimesData)
..addAll(checkBoxGroupesData)
..addAll(radioGroupesData)
..addAll(selectsData)
..addAll(paragraphsData);

String getCocarDataAsString() => json.encode(allData);

final List<Map> headersData = [
  {
    "type": "header",
    "subtype": "h1",
    "label": "Título",
    "access": false
  },
  {
    "type": "header",
    "subtype": "h2",
    "label": "Título",
    "access": false
  },
  {
    "type": "header",
    "subtype": "h3",
    "label": "Título",
    "access": false
  },
  {
    "type": "header",
    "subtype": "h4",
    "label": "Título",
    "access": false
  },
  {
    "type": "header",
    "subtype": "h5",
    "label": "Título",
    "access": false
  },
  {
    "type": "header",
    "subtype": "h6",
    "label": "Título",
    "access": false
  }
];

final List<Map> paragraphsData = [
  {
    "type": "paragraph",
    "subtype": "p",
    "label": "Párrafo",
    "access": false
  },
  {
    "type": "paragraph",
    "subtype": "address",
    "label": "Párrafo",
    "access": false
  },
  {
    "type": "paragraph",
    "subtype": "blockquote",
    "label": "Párrafo",
    "access": false
  },
  {
    "type": "paragraph",
    "subtype": "canvas",
    "label": "Párrafo",
    "access": false
  },
  {
    "type": "paragraph",
    "subtype": "output",
    "label": "Párrafo",
    "access": false
  }
];


final List<Map> textsData = [
  {
    "type": "text",
    "subtype": "password",
    "required": false,
    "label": "Campo de password",
    "className": "form-control",
    "name": "text-1614268515156",
    "access": false,
    "value": "Partes2018"
  },
  {
    "type": "text",
    "subtype": "email",
    "required": false,
    "label": "Campo de email",
    "className": "form-control",
    "name": "text-1614268513997",
    "access": false,
    "value": "sss"
  },
  {
    "type": "text",
    "subtype": "color",
    "required": false,
    "label": "Campo de color",
    "className": "form-control",
    "name": "text-1614268513549",
    "access": false
  },
  {
    "type": "text",
    "subtype": "tel",
    "required": false,
    "label": "Campo de telefono",
    "className": "form-control",
    "name": "text-1614268513053",
    "access": false
  },
  {
    "type": "text",
    "required": false,
    "label": "Campo de Texto con placeholder",
    "placeholder": "aqui va el placeholder",
    "className": "form-control",
    "name": "text-1614268512526",
    "access": false,
    "subtype": "text"
  },
  {
    "type": "text",
    "required": false,
    "label": "Campo de Texto con valor",
    "className": "form-control",
    "name": "text-1614268681010",
    "access": false,
    "value": "aqui va el valor",
    "subtype": "text"
  },
  {
    "type": "text",
    "required": false,
    "label": "Campo de Texto con longitud maxima",
    "className": "form-control",
    "name": "text-1614268704412",
    "access": false,
    "value": "1234567890",
    "subtype": "text",
    "maxlength": 10
  },
  {
    "type": "text",
    "required": false,
    "label": "Campo de Texto contexto de ayuda",
    "description": "este campo sirve para explicar el funcionamiento del input",
    "className": "form-control",
    "name": "text-1614268993381",
    "access": false,
    "value": "1234567890",
    "subtype": "text"
  }
];

final List<Map<String, dynamic>> textAreasData = [
  {
    "type": "textarea",
    "required": false,
    "label": "Área de texto simple",
    "className": "form-control",
    "name": "textarea-1614270177669",
    "access": false,
    "subtype": "textarea"
  },
  {
    "type": "textarea",
    "required": false,
    "label": "Área de texto con longitud maxima",
    "className": "form-control",
    "name": "textarea-1614270215579",
    "access": false,
    "subtype": "textarea",
    "maxlength": 15
  },
  {
    "type": "textarea",
    "required": false,
    "label": "Área de texto con lfilas",
    "className": "form-control",
    "name": "textarea-1614270238635",
    "access": false,
    "subtype": "textarea",
    "rows": 10
  },
  
];

final List<Map> numbersData = [
  {
    "type": "number",
    "required": false,
    "label": "Número",
    "className": "form-control",
    "name": "number-1614269116864",
    "access": false,
    "min": 10
  },
  {
    "type": "number",
    "required": false,
    "label": "Número",
    "className": "form-control",
    "name": "number-1614269124812",
    "access": false,
    "max": 100
  },
  {
    "type": "number",
    "required": false,
    "label": "Número",
    "className": "form-control",
    "name": "number-1614269124263",
    "access": false,
    "step": 5
  }
];

final List<Map> selectsData = [
  {
    "type": "select",
    "required": false,
    "label": "Seleccionable simple",
    "className": "form-control",
    "name": "select-1614270112039",
    "access": false,
    "multiple": false,
    "values": [
      {
        "label": "Opcion 1",
        "value": "opcion-1"
      },
      {
        "label": "Opcion 2",
        "value": "opcion-2"
      },
      {
        "label": "Opcion 3",
        "value": "opcion-3"
      }
    ]
  },
  {
    "type": "select",
    "required": false,
    "label": "Seleccionable multiple",
    "className": "form-control",
    "name": "select-1614270122716",
    "access": false,
    "multiple": true,
    "values": [
      {
        "label": "Opcion 1",
        "value": "opcion-1",
        "selected": true
      },
      {
        "label": "Opcion 2",
        "value": "opcion-2"
      },
      {
        "label": "Opcion 3",
        "value": "opcion-3"
      }
    ]
  }
];

final List<Map> datesAndTimesData = [
  {
    "type": "date",
    "required": false,
    "label": "Campo de Fecha",
    "className": "form-control",
    "name": "date-1614269224975",
    "access": false
  },
  {
    "type": "time",
    "required": false,
    "label": "Campo de tiempo",
    "className": "form-control",
    "name": "time-1614269249717",
    "access": false
  }
];

final List<Map> checkBoxGroupesData = [
  {
    "type": "checkbox-group",
    "required": false,
    "label": "Grupo de casillas simple",
    "toggle": false,
    "inline": false,
    "name": "checkbox-group-1614269471449",
    "access": false,
    "other": false,
    "values": [
      {
        "label": "Opcion 1",
        "value": "opcion-1",
        "selected": true
      }
    ]
  },
  {
    "type": "checkbox-group",
    "required": false,
    "label": "Grupo de casillas multiple",
    "toggle": false,
    "inline": false,
    "name": "checkbox-group-1614269483789",
    "access": false,
    "other": false,
    "values": [
      {
        "label": "Opcion 1",
        "value": "opcion-1",
        "selected": true
      },
      {
        "label": "opcion2",
        "value": "valor-2"
      }
    ]
  },
  {
    "type": "checkbox-group",
    "required": false,
    "label": "Grupo de casillas multiple lineal",
    "toggle": false,
    "inline": true,
    "name": "checkbox-group-1614269507380",
    "access": false,
    "other": false,
    "values": [
      {
        "label": "Opcion 1",
        "value": "opcion-1",
        "selected": true
      },
      {
        "label": "opcion2",
        "value": "valor-2"
      }
    ]
  }
];

final List<Map> radioGroupesData = [{
    "type": "radio-group",
    "required": false,
    "label": "Grupo de Selección radio",
    "inline": false,
    "name": "radio-group-1614269987989",
    "access": false,
    "other": false,
    "values": [
      {
        "label": "Opcion 1",
        "value": "opcion-1"
      },
      {
        "label": "Opcion 2",
        "value": "opcion-2",
        "selected": true
      },
      {
        "label": "Opcion 3",
        "value": "opcion-3"
      }
    ]
  }];
