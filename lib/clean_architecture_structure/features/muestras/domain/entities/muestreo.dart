import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/rango.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';

// ignore: must_be_immutable
class Muestreo extends Equatable{
  final int id;
  final String tipo;
  final bool obligatorio;
  final List<String> stringRangos;
  final List<Componente> componentes;
  final List<Muestra> muestrasTomadas;
  final List<Rango> rangos;
  final int minMuestras;
  final int maxMuestras;
  final int nMuestras;
  final Formulario preFormulario;
  final Formulario posFormulario;

  Muestreo({
    @required this.id,
    @required this.tipo,
    @required this.obligatorio,
    @required this.stringRangos,
    @required this.componentes,
    @required this.muestrasTomadas,
    @required this.rangos,
    @required this.minMuestras,
    @required this.maxMuestras,    
    @required this.nMuestras,
    @required this.preFormulario,
    @required this.posFormulario
  });

  // ignore: missing_return
  Muestreo copyWith({
    List<Rango> rangos,
    int nMuestras
  }){}

  @override
  List<Object> get props => [
    this.id,
    this.tipo,
    this.obligatorio,
    this.stringRangos,
    this.componentes, 
    this.muestrasTomadas, 
    this.nMuestras, 
    this.preFormulario,
    this.posFormulario
  ];
}