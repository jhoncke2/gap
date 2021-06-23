import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/custom_position.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/firmer.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

abstract class FormulariosRepository{
  Future<Either<Failure, List<Formulario>>> getFormularios();
  Future<Either<Failure, void>> setChosenFormulario(Formulario formulario);
  Future<Either<Failure, Formulario>> getChosenFormulario();
  Future<Either<Failure, void>> setInitialPosition(CustomPosition position);
  Future<Either<Failure, void>> setCampos(Formulario formulario);
  Future<Either<Failure, void>> setFinalPosition(CustomPosition position);
  Future<Either<Failure, void>> setFirmer(Firmer firmer);
  Future<Either<Failure, void>> endChosenFormulario();
}