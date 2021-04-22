import 'package:gap/clean_architecture_structure/core/data/models/formulario/firmer_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:geolocator/geolocator.dart';

abstract class FormulariosRemoteDataSource{
  Future<List<FormularioModel>> getFormularios(String accessToken);
  Future<void> setInitialPosition(Position position, int formularioId, String accessToken);
  Future<void> setFormulario(FormularioModel formulario, int visitId, int projectId, String accessToken);
  Future<void> setFinalPosition(Position position, int formularioId, String accessToken);
  Future<void> setFirmer(FirmerModel firmer, int formularioId, String accessToken);
}