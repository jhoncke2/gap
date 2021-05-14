import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/repository/fake_impl/fake_muestra.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';

class MuestrasRepositoryFake implements MuestrasRepository{
  @override
  Future<Either<Failure, Muestreo>> getMuestreo()async{
    return Right(fakeMuestra);
  }

  @override
  Future<Either<Failure, void>> setMuestra(int selectedRangoIndex, List<double> pesosTomados)async{
    // TODO: implement setMuestra
    throw UnimplementedError();
  }

}