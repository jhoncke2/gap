import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/formulario.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/firmer.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/formulario/custom_position.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/formularios_repository.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import './fake_formularios.dart' as fakeFormularios; 

class FormulariosRepositoryFake implements FormulariosRepository{

  List<FormularioModel> formularios = fakeFormularios.formularios;
  FormularioModel chosenFormulario;

  @override
  Future<Either<Failure, List<Formulario>>> getFormularios()async{
    return Right(formularios);
  }

  @override
  Future<Either<Failure, void>> setChosenFormulario(Formulario formulario)async{
    this.chosenFormulario = formularios.singleWhere((f) => f.id == formulario.id);
    return Right(null);
  }

  @override
  Future<Either<Failure, Formulario>> getChosenFormulario()async{
    if(this.chosenFormulario == null)
      this.chosenFormulario = formularios[0];
    return Right(chosenFormulario);
  }

  @override
  Future<Either<Failure, void>> setInitialPosition(CustomPosition position)async{
    this.chosenFormulario.initialPosition = position;
    return Right(null);
  }

  @override
  Future<Either<Failure, void>> setCampos(Formulario formulario)async{
    this.chosenFormulario.campos = formulario.campos;
    return Right(null);
  }

  @override
  Future<Either<Failure, void>> setFinalPosition(CustomPosition position)async{
    this.chosenFormulario.finalPosition = position;
    return Right(null);
  }

  @override
  Future<Either<Failure, void>> endChosenFormulario()async{
    this.chosenFormulario.completo = true;
    this.chosenFormulario = null;
    return Right(null);
  }
  
  //TODO: Quitar siguiente método de FormulkariosRepository
  @override
  Future<Either<Failure, void>> setFirmer(Firmer firmer) {
    // TODO: implement setFirmer
    throw UnimplementedError();
  }
}