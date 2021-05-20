import 'package:gap/clean_architecture_structure/features/muestras/data/models/rango_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';

final Muestreo fakeMuestreo = Muestreo(
  id: 1,
  tipo: 'Almuerzo', 
  obligatorio: true,
  rangos: [
    RangoModel(id: 1, nombre: '5-8 años', pesosEsperados: [20.0, 40.0, 100.0], completo: false),
    RangoModel(id: 2, nombre: '9-12 años', pesosEsperados: [30.0, 65.0, 125.0], completo: false)
  ],
  pesosEsperadosPorRango: [
    [20.0, 40.0, 100.0],
    [30.0, 65.0, 125.0]
  ],
  stringRangos: ['5-8 años', '9-12 años'], 
  componentes: [
    Componente(
      nombre: 'Lácteos',
      preparacion: null
    ),
    Componente(
      nombre: 'Cereales',
      preparacion: null
    ),
    Componente(
      nombre: 'Protéicos',
      preparacion: null,
    ),
  ],
  muestrasTomadas: [
    
  ],
  minMuestras: 1,
  maxMuestras: 3,
  nMuestras: 0
);