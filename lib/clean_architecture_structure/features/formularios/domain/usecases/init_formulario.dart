import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

class InitChosenFormulario implements UseCase<Formulario, NoParams>{
  final FormulariosRepository repository;
  final UseCaseErrorHandler errorHandler;

  InitChosenFormulario({
    @required this.repository, 
    @required this.errorHandler
  });

  @override
  Future<Either<Failure, Formulario>> call(NoParams params)async{
    return await errorHandler.executeFunction<Formulario>(() => repository.getChosenFormulario());
  }
}