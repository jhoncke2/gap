import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';

class GetFormulario implements UseCase<Formulario, MuestreoFormularioParams>{
  final MuestrasRepository repository;
  final UseCaseErrorHandler errorHandler;

  GetFormulario({
    @required this.repository, 
    @required this.errorHandler
  });

  @override
  Future<Either<Failure, Formulario>> call(MuestreoFormularioParams params)async{
    return await errorHandler.executeFunction<Formulario>(() => repository.getFormulario(params.formularioId));
  }
}

class MuestreoFormularioParams extends Equatable{
  final int formularioId;

  MuestreoFormularioParams({
    @required this.formularioId
  });

  @override
  List<Object> get props => [this.formularioId];
}