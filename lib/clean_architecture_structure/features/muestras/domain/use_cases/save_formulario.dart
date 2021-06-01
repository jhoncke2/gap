import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/features/muestras/domain/repositories/muestras_repository.dart';


class SaveFormulario implements UseCase<void, SaveFormularioParams>{

  final MuestrasRepository repository;
  final UseCaseErrorHandler errorHandler;
  SaveFormulario({
    @required this.repository,
    @required this.errorHandler
  });

  @override
  Future<Either<Failure, void>> call(SaveFormularioParams params)async{
    return await errorHandler.executeFunction(() => repository.setFormulario(params.muestreoId, params.formulario, params.formularioType));
  }

}

class SaveFormularioParams extends Equatable{
  final int muestreoId;
  final Formulario formulario;
  final String formularioType;
  SaveFormularioParams({
    @required this.muestreoId,
    @required this.formulario,
    @required this.formularioType
  });
  @override
  List<Object> get props => [
    this.muestreoId,
    this.formulario,
    this.formularioType
  ];
  
}