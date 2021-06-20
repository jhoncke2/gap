import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';

class SetChosenFormulario implements UseCase<void, ChooseFormularioParams>{
  final FormulariosRepository repository;
  final UseCaseErrorHandler errorHandler;

  SetChosenFormulario({
    @required this.repository, 
    @required this.errorHandler
  });

  @override
  Future<Either<Failure, void>> call(ChooseFormularioParams params)async{
    return await errorHandler.executeFunction<void>(() => repository.setChosenFormulario(params.formulario));
  }

}

class ChooseFormularioParams extends Equatable{
  final Formulario formulario;
  ChooseFormularioParams({@required this.formulario});

  @override
  List<Object> get props => [this.formulario];
}