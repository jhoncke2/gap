import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class FormulariosStorageManager{
  static final String _formsKey = 'formularios';

  static Future<void> setForms(List<OldFormulario> forms)async{
    final List<Map<String, dynamic>> formsAsJson = _convertFormsToJson(forms);
    await StorageConnectorSingleton.storageConnector.setListResource(_formsKey, formsAsJson);
  }

  static List<Map<String, dynamic>> _convertFormsToJson(List<OldFormulario> forms){
    final List<Map<String, dynamic>> formsAsJson = forms.map<Map<String, dynamic>>(
      (OldFormulario form)=>form.toJson()
    ).toList();
    return formsAsJson;
  }

  static Future<List<OldFormulario>> getForms()async{
    final List<Map<String, dynamic>> formsAsJson = await StorageConnectorSingleton.storageConnector.getListResource(_formsKey);
    final List<OldFormulario> forms = _convertJsonFormsToObject(formsAsJson);
    return forms;
  }

  static List<OldFormulario> _convertJsonFormsToObject(List<Map<String, dynamic>> formsAsJson){
    return formsAsJson.map<OldFormulario>(
      (Map<String, dynamic> jsonForm) => OldFormulario.fromJson(jsonForm)
    ).toList();
  }

  static Future<void> removeForms()async{
    await StorageConnectorSingleton.storageConnector.removeResource(_formsKey);
  }
}