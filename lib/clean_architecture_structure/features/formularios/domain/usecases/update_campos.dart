import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/params/campos_params.dart';

class UpdateCampos implements UseCase<void, CamposParams>{

  final FormulariosRepository repository;
  final UseCaseErrorHandler errorHandler;

  UpdateCampos({
    @required this.repository, 
    @required this.errorHandler
  });

  @override
  Future<Either<Failure, void>> call(CamposParams params)async{
    return await errorHandler.executeFunction<void>(()async{
      final eitherChosenFormulario = await repository.getChosenFormulario();
      return await eitherChosenFormulario.fold((_){

      }, (formulario)async{
        formulario.campos = params.campos;
        await repository.setChosenFormulario(formulario);
        return Right(null);
      });
    });
  }
  
}