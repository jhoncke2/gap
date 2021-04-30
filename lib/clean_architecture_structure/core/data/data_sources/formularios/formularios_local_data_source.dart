import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';

abstract class FormulariosLocalDataSource{
  Future<void> setFormularios(List<FormularioModel> formularios, int visitId);
  Future<List<FormularioModel>> getFormularios(int visitId);
  Future<void> setChosenFormulario(FormularioModel formulario, int visitId);
  Future<FormularioModel> getChosenFormulario(int visitId);
  Future<void> deleteAll();
}

class FormulariosLocalDataSourceImpl implements FormulariosLocalDataSource{
  static const FORMULARIOS_STORAGE_KEY = 'formularios_of';
  static const CHOSEN_FORMULARIO_STORAGE_KEY = 'chosen_formulario';
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
    return '${FORMULARIOS_STORAGE_KEY}_$visitId';
  }

  @override
  Future<List<FormularioModel>> getFormularios(int visitId)async{
    final List<Map<String, dynamic>> jsonFormularios = await storageConnector.getList('${FORMULARIOS_STORAGE_KEY}_$visitId');
    return formulariosFromJson(jsonFormularios);
  }

  @override
  Future<void> setChosenFormulario(FormularioModel formulario, int visitId)async{
    await storageConnector.setString('${formulario.id}', CHOSEN_FORMULARIO_STORAGE_KEY);
    List<FormularioModel> formularios = await getFormularios(visitId);
    formularios = formularios.map((f) => (f.id == formulario.id)? formulario : f).toList();
    await setFormularios(formularios, visitId);
  }

  @override
  Future<FormularioModel> getChosenFormulario(int visitId)async{
    final String stringChosenFormularioId = await storageConnector.getString(CHOSEN_FORMULARIO_STORAGE_KEY);
    return _tryGetFormularioFromStorage(stringChosenFormularioId, visitId);
  }

  Future<FormularioModel> _tryGetFormularioFromStorage(String stringChosenFormularioId, int visitId)async{
    try{
      final int chosenFormularioId = int.parse(stringChosenFormularioId);
      final List<Map<String, dynamic>> jsonFormulariosOfVisit = await storageConnector.getList(_getFormulariosByVisitStorageKey(visitId));
      final Map<String, dynamic> jsonChosenFormulario = jsonFormulariosOfVisit.firstWhere((f) => f['formulario_pivot_id']  == chosenFormularioId);
      final FormularioModel chosenFormulario = FormularioModel.fromJson(jsonChosenFormulario);
      return chosenFormulario;
    }catch(err){
      return FormularioModel(id: null, completo: false);
    }
  }

  Future<void> deleteAll()async{
    await storageConnector.remove(CHOSEN_FORMULARIO_STORAGE_KEY);
    await storageConnector.remove(FORMULARIOS_STORAGE_KEY);
  }
}