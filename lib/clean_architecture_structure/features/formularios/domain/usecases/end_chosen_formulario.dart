import 'package:gap/clean_architecture_structure/features/formularios/domain/usecases/params/campos_params.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/custom_position.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/use_case_error_handler.dart';
import 'package:gap/clean_architecture_structure/core/domain/helpers/usecase_permissions_manager.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/platform/locator.dart';

class EndChosenFormulario implements UseCase<void, CamposParams>{
  final FormulariosRepository repository;
  final UseCaseErrorHandler errorHandler;
  final UseCasePermissionsManager permissions;
  final CustomLocator locator;

  EndChosenFormulario({
    @required this.repository, 
    @required this.errorHandler, 
    @required this.permissions, 
    @required this.locator
  });
  
  
  @override
  Future<Either<Failure, void>> call(CamposParams params)async{
    return await errorHandler.executeFunction<void>(()async=>
      await permissions.executeFunctionByValidateLocation(()async{
        final CustomPosition currentPosition = await locator.gpsPosition;
        final eitherSetFinalPosition = await repository.setFinalPosition(currentPosition);
        if(eitherSetFinalPosition.isLeft())
          return eitherSetFinalPosition;
        final eitherChosenFormulario = await repository.getChosenFormulario();
        return await eitherChosenFormulario.fold((l){
          //TODO: Implementar manejo de errores
        }, (chosenFormulario)async => _updateCampos(chosenFormulario, params.campos)
        );
      })
    );
  }

  Future<Either<Failure, void>> _updateCampos(Formulario chosenFormulario, List<CustomFormFieldOld> campos)async{
    chosenFormulario.campos = campos;
    await repository.setChosenFormulario(chosenFormulario);
    final eitherSetCampos = await repository.setCampos(chosenFormulario);
    if(eitherSetCampos.isLeft())
      return eitherSetCampos;
    await repository.endChosenFormulario();
    return Right(null);
  }

}