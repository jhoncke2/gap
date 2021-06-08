import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';

import 'muestra_model.dart';
import 'componente_model.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/rango_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/rango.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';

// ignore: must_be_immutable
class MuestreoModel extends Muestreo{
  MuestreoModel({
    @required int id,
    @required String tipo,
    @required List<String> stringRangos,
    @required List<ComponenteModel> componentes,
    @required List<MuestraModel> muestrasTomadas,
    @required List<RangoModel> rangos,
    @required bool obligatorio,
    @required int minMuestras,
    @required int maxMuestras,    
    @required int nMuestras,
    @required FormularioModel preFormulario,
    @required FormularioModel posFormulario
  }):super(
    id: id,
    tipo: tipo,
    stringRangos: stringRangos,
    componentes: componentes,
    muestrasTomadas: muestrasTomadas,
    rangos: rangos,
    obligatorio: obligatorio,
    minMuestras: minMuestras,
    maxMuestras: maxMuestras,    
    nMuestras: nMuestras,
    preFormulario: preFormulario,
    posFormulario: posFormulario
  );

  factory MuestreoModel.fromRemoteJson(Map<String, dynamic> json)=>MuestreoModel(
    id: json['id'],
    tipo: json['tipo'],
    stringRangos: [''],
    componentes: componentesFromRemoteJson(json),
    rangos:  rangosFromJson( json['rangos'].cast<Map<String, dynamic>>() ),
    muestrasTomadas: json['muestras'] != null? muestrasFromJson(json['muestras'].cast<Map<String, dynamic>>()): [],
    obligatorio: json['obligatorio'],
    minMuestras: json['n_muestreos'][0],
    maxMuestras: json['n_muestreos'][1],
    nMuestras: ( json['muestras']??[] ).length,
    preFormulario: json['pre_formulario'] == null? null : _getFormularioFromCampos( json['pre_formulario'] ),
    posFormulario: json['pos_formulario'] == null? null : _getFormularioFromCampos( json['pos_formulario'] )
  );

  factory MuestreoModel.fromLocalJson(Map<String, dynamic> json)=>MuestreoModel(
    id: json['id'],
    tipo: json['tipo'],
    stringRangos: [''],
    componentes: componentesFromLocalJson(json['componentes'].cast<Map<String, dynamic>>()),
    rangos:  rangosFromJson( json['rangos'].cast<Map<String, dynamic>>() ),
    muestrasTomadas: json['muestras'] != null? muestrasFromJson(json['muestras'].cast<Map<String, dynamic>>()): [],
    obligatorio: json['obligatorio'],
    minMuestras: json['n_muestreos'][0],
    maxMuestras: json['n_muestreos'][1],
    nMuestras: ( json['muestras']??[] ).length,
    preFormulario: json['pre_formulario'] == null? null : FormularioModel.fromJson( json['pre_formulario'] ),
    posFormulario: json['pos_formulario'] == null? null : FormularioModel.fromJson( json['pos_formulario'] )
  );

  static FormularioModel _getFormularioFromCampos(Map<String, dynamic> jsonFormulario){
    FormularioModel formularioModel = FormularioModel.fromJson( jsonFormulario );
    formularioModel.name = jsonFormulario['nombre'];
    return formularioModel;
  }

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'tipo': this.tipo,
    'componentes': componentesToLocalJson(this.componentes),
    'rangos': rangosToJson(this.rangos),
    'muestras': muestrasToJson( this.muestrasTomadas ),
    'obligatorio': this.obligatorio,
    'n_muestreos':[ minMuestras, maxMuestras ],
    'pre_formulario': (this.preFormulario as FormularioModel).toJson(),
    'pos_formulario': (this.posFormulario as FormularioModel).toJson()
  };

  @override
  Muestreo copyWith({
    int nMuestras,
    List<Rango> rangos,
    Formulario preFormulario,
    Formulario posFormulario
  })=>MuestreoModel(
    id: this.id,    
    tipo: this.tipo,
    obligatorio: this.obligatorio,
    stringRangos: this.stringRangos,
    componentes: this.componentes,
    muestrasTomadas: this.muestrasTomadas,
    rangos: (rangos ?? this.rangos).cast<RangoModel>(),
    minMuestras: this.minMuestras,
    maxMuestras: this.maxMuestras,
    nMuestras: nMuestras ?? this.nMuestras,
    preFormulario: preFormulario ?? this.preFormulario,
    posFormulario: posFormulario ?? this.posFormulario
  );
}