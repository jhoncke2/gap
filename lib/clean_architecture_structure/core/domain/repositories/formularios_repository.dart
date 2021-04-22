import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/firmer.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:geolocator/geolocator.dart';

abstract class FormulariosRepository{
  Future<Either<Failure, List<Formulario>>> getFormularios();
  Future<Either<Failure, void>> setInitialPosition(Position position);
  Future<Either<Failure, void>> setFormulario(Formulario formulario);
  Future<Either<Failure, void>> setFinalPosition(Position position);
  Future<Either<Failure, void>> setFirmer(Firmer firmer);
}