import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/custom_position.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/usecase_permissions_manager.dart';
import 'package:gap/clean_architecture_structure/core/platform/locator.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';

class ChooseFormulario implements UseCase<void, ChooseFormularioParams>{
  final FormulariosRepository repository;
  final UseCaseErrorHandler errorHandler;
  final UseCasePermissionsManager permissions;
  final CustomLocator locator;

  ChooseFormulario({
    @required this.repository, 
    @required this.errorHandler,
    @required this.permissions,
    @required this.locator
  });

  @override
  Future<Either<Failure, void>> call(ChooseFormularioParams params)async{
    return await errorHandler.executeFunction<void>(
      () => permissions.executeFunctionByValidateLocation<void>(()async{
        final CustomPosition position = await locator.gpsPosition;
        final eitherSetChosenFormulario = await repository.setChosenFormulario(params.formulario);
        await repository.setInitialPosition(position);
        return eitherSetChosenFormulario;
      }
    )
    );
  }
}

class ChooseFormularioParams extends Equatable{
  final Formulario formulario;
  ChooseFormularioParams({@required this.formulario});

  @override
  List<Object> get props => [this.formulario];
}