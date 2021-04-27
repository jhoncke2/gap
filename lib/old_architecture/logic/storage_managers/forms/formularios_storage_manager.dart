import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/native_connectors/storage_connector.dart';

class FormulariosStorageManager{
  static final String _formsKey = 'formularios_old';

  static Future<void> setForms(List<FormularioOld> forms)async{
    final List<Map<String, dynamic>> formsAsJson = _convertFormsToJson(forms);
    await StorageConnectorOldSingleton.storageConnector.setListResource(_formsKey, formsAsJson);
  }

  static List<Map<String, dynamic>> _convertFormsToJson(List<FormularioOld> forms){
    final List<Map<String, dynamic>> formsAsJson = forms.map<Map<String, dynamic>>(
      (FormularioOld form)=>form.toJson()
    ).toList();
    return formsAsJson;
  }

  static Future<List<FormularioOld>> getForms()async{
    final List<Map<String, dynamic>> formsAsJson = await StorageConnectorOldSingleton.storageConnector.getListResource(_formsKey);
    final List<FormularioOld> forms = _convertJsonFormsToObject(formsAsJson);
    return forms;
  }

  static List<FormularioOld> _convertJsonFormsToObject(List<Map<String, dynamic>> formsAsJson){
    return formsAsJson.map<FormularioOld>(
      (Map<String, dynamic> jsonForm) => FormularioOld.fromJson(jsonForm)
    ).toList();
  }

  static Future<void> removeForms()async{
    await StorageConnectorOldSingleton.storageConnector.removeResource(_formsKey);
  }
}