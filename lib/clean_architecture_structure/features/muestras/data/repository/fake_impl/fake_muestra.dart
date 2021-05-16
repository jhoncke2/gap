import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';

final Muestreo fakeMuestreo = Muestreo(
  tipo: 'Almuerzo', 
  obligatorio: true,
  pesosEsperadosPorRango: [
    [20.0, 40.0, 100.0],
    [30.0, 65.0, 125.0]
  ],
  rangos: ['5-8 años', '9-12 años'], 
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