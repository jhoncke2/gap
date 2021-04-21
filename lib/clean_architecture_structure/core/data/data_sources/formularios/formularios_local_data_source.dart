import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';

abstract class FormulariosLocalDataSource{
  Future<void> setFormularios(List<FormularioModel> formularios, int visitId);
  Future<List<FormularioModel>> getFormularios(int visitId);
  Future<void> setChosenFormulario(FormularioModel formulario);
  Future<FormularioModel> getChosenFormulario(int visitId);
}

class FormulariosLocalDataSourceImpl implements FormulariosLocalDataSource{
  static const baseFormulariosStorageKey = 'formularios_of';
  static const chosenFormularioStorageKey = 'chosen_formulario';
  final StorageConnector storageConnector;

  FormulariosLocalDataSourceImpl({
    @required this.storageConnector
  });

  @override
  Future<void> setFormularios(List<FormularioModel> formularios, int visitId)async{
    final List<Map<String, dynamic>> jsonFormularios = formulariosToJson(formularios);
    await storageConnector.setList(jsonFormularios, _getFormulariosByVisitStorageKey(visitId));
  }

  String _getFormulariosByVisitStorageKey(int visitId){
    return '${baseFormulariosStorageKey}_$visitId';
  }

  @override
  Future<List<FormularioModel>> getFormularios(int visitId)async{
    final List<Map<String, dynamic>> jsonFormularios = await storageConnector.getList('${baseFormulariosStorageKey}_$visitId');
    return formulariosFromJson(jsonFormularios);
  }

  @override
  Future<void> setChosenFormulario(FormularioModel formulario)async{
    await storageConnector.setString('${formulario.id}', chosenFormularioStorageKey);
  }

  @override
  Future<FormularioModel> getChosenFormulario(int visitId)async{
    final String stringChosenFormularioId = await storageConnector.getString(chosenFormularioStorageKey);
    final int chosenFormularioId = int.parse(stringChosenFormularioId);
    final List<Map<String, dynamic>> jsonFormulariosOfVisit = await storageConnector.getList(_getFormulariosByVisitStorageKey(visitId));
    final Map<String, dynamic> jsonChosenFormulario = jsonFormulariosOfVisit.firstWhere((f) => f['formulario_pivot_id']  == chosenFormularioId);
    final FormularioModel chosenFormulario = FormularioModel.fromJson(jsonChosenFormulario);
    return chosenFormulario;
  }
}