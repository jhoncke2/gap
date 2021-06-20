import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';

class GetFormularios implements UseCase<List<Formulario>, NoParams>{
  final FormulariosRepository repository;
  final UseCaseErrorHandler errorHandler;

  GetFormularios({
    @required this.repository, 
    @required this.errorHandler
  });

  @override
  Future<Either<Failure, List<Formulario>>> call(NoParams params)async{
    return await errorHandler.executeFunction<List<Formulario>>(() => repository.getFormularios());
  }

}