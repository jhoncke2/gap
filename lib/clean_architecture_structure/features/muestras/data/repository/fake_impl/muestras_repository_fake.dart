import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/componente_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestra_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/repository/fake_impl/fake_muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/componente.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';

class MuestrasRepositoryFake implements MuestrasRepository{

  int nSavedMuestras = 0;
  MuestraModel lastSettedMuestra;

  @override
  Future<Either<Failure, Muestreo>> getMuestreo()async{
    if(lastSettedMuestra != null){
      fakeMuestreo.muestrasTomadas.add(lastSettedMuestra);
      lastSettedMuestra = null;
    }
    return Right(fakeMuestreo);
  }

  @override
  Future<Either<Failure, void>> setMuestra(int selectedRangoIndex, List<double> pesosTomados)async{
    lastSettedMuestra = MuestraModel(
      id: ++nSavedMuestras,
      rango: fakeMuestreo.rangos[selectedRangoIndex], 
      pesos: pesosTomados
    );
    return Right(null);
  }

  @override
  Future<Either<Failure, void>> updatePreparaciones(List<String> preparaciones)async{
    List<Componente> componentes = fakeMuestreo.componentes;
    for(int i = 0; i < componentes.length; i++){
      componentes[i] = ComponenteModel(nombre: componentes[i].nombre, preparacion: preparaciones[i]);
    }
    return Right(null);
  }

  @override
  Future<Either<Failure, void>> removeMuestra(int muestraId)async{
    fakeMuestreo.muestrasTomadas.removeWhere((m) => m.id == muestraId);
    fakeMuestreo.nMuestras--;
    return Right(null);
  }
}