import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:gap/clean_architecture_structure/core/data/data_sources/central/remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/custom_position.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/firmer_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';

abstract class FormulariosRemoteDataSource{
  Future<List<FormularioModel>> getFormularios(int visitId, String accessToken);
  Future<FormularioModel> getChosenFormulario(int formularioId, String accessToken);
  Future<void> setInitialPosition(CustomPositionModel position, int formularioId, String accessToken);
  Future<void> setFormulario(FormularioModel formulario, int visitId, String accessToken);
  Future<void> setFinalPosition(CustomPositionModel position, int formularioId, String accessToken);
  Future<void> setFirmer(FirmerModel firmer, int formularioId, String accessToken);
}

class FormulariosRemoteDataSourceImpl extends RemoteDataSource implements FormulariosRemoteDataSource{
  final http.Client client;

  FormulariosRemoteDataSourceImpl({
    @required this.client
  });

  @override
  Future<FormularioModel> getChosenFormulario(int formularioId, String accessToken) {
    // TODO: implement getChosenFormulario
    throw UnimplementedError();
  }

  @override
  Future<List<FormularioModel>> getFormularios(int visitId, String accessToken) {
    // TODO: implement getFormularios
    throw UnimplementedError();
  }

  @override
  Future<void> setFinalPosition(CustomPositionModel position, int formularioId, String accessToken) {
    // TODO: implement setFinalPosition
    throw UnimplementedError();
  }

  @override
  Future<void> setFirmer(FirmerModel firmer, int formularioId, String accessToken) {
    // TODO: implement setFirmer
    throw UnimplementedError();
  }

  @override
  Future<void> setFormulario(FormularioModel formulario, int visitId, String accessToken) {
    // TODO: implement setFormulario
    throw UnimplementedError();
  }

  @override
  Future<void> setInitialPosition(CustomPositionModel position, int formularioId, String accessToken) {
    // TODO: implement setInitialPosition
    throw UnimplementedError();
  }

}