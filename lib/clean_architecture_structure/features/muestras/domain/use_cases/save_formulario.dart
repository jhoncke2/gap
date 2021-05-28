import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class SaveFormulario implements UseCase<void, SaveFormularioParams>{

  final MuestrasRepository repository;
  final UseCaseErrorHandler errorHandler;
  SaveFormulario({
    @required this.repository,
    @required this.errorHandler
  });

  @override
  Future<Either<Failure, void>> call(SaveFormularioParams params)async{
    return await errorHandler.executeFunction(() => repository.setFormulario(params.formulario));
  }

}

class SaveFormularioParams extends Equatable{
  final Formulario formulario;
  SaveFormularioParams({
    @required this.formulario
  });

  @override
  List<Object> get props => [this.formulario];
  
}