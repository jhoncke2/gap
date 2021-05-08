import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/rango_toma.dart';

final Muestra fakeMuestra = Muestra(
  nMuestreos: 0,
  tipo: 'Almuerzo', 
  rangos: ['5-8 años', '9-12 años'], 
  componentes: [
    Componente(
      nombre: 'Lácteos', 
      preparacion: null, 
      valoresPorRango: [
        RangoToma(rango: '5-8 años', pesoEsperado: 20.0, pesosTomados: []),
        RangoToma(rango: '9-12 años', pesoEsperado: 30.0, pesosTomados: [])
      ]
    ),
    Componente(
      nombre: 'Cereales', 
      preparacion: null, 
      valoresPorRango: [
        RangoToma(rango: '5-8 años', pesoEsperado: 40.0, pesosTomados: []),
        RangoToma(rango: '9-12 años', pesoEsperado: 65.0, pesosTomados: [])
      ]
    ),
    Componente(
      nombre: 'Protéicos', 
      preparacion: null, 
      valoresPorRango: [
        RangoToma(rango: '5-8 años', pesoEsperado: 100.0, pesosTomados: []),
        RangoToma(rango: '9-12 años', pesoEsperado: 125.0, pesosTomados: [])
      ]
    ),
  ]
);