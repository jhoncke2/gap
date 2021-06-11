import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/entities/muestreo.dart';

abstract class MuestrasRepository{
  Future<Either<Failure, Muestreo>> getMuestreo();
  //TODO: Quitar el muestreoId cuando haya implementado la carga en el storage
  Future<Either<Failure, void>> setFormulario( int muestreoId, Formulario formulario, String tipo );
  Future<Either<Failure, void>> setMuestra(int muestreoId, int selectedRangoId, List<double> pesosTomados);
  Future<Either<Failure, void>> updatePreparaciones(int muestreoId, List<String> preparaciones);
  Future<Either<Failure, void>> removeMuestra(int muestraId);
  Future<Either<Failure, void>> endMuestreo();
}