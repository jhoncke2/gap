import 'package:gap/clean_architecture_structure/core/data/models/formulario/custom_position.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/firmer_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';

abstract class FormulariosRemoteDataSource{
  Future<List<FormularioModel>> getFormularios(String accessToken);
  Future<void> setInitialPosition(CustomPositionModel position, int formularioId, String accessToken);
  Future<void> setFormulario(FormularioModel formulario, int visitId, String accessToken);
  Future<void> setFinalPosition(CustomPositionModel position, int formularioId, String accessToken);
  Future<void> setFirmer(FirmerModel firmer, int formularioId, String accessToken);
}