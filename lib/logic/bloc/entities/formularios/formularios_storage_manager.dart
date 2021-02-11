import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class FormulariosStorageManager{
  static final String formsKey = 'formularios';

  static Future<void> setForms(List<Formulario> forms)async{
    final List<Map<String, dynamic>> formsAsJson = _convertFormsToJson(forms);
    await StorageConnectorSingleton.storageConnector.setListResource(formsKey, formsAsJson);
  }

  static List<Map<String, dynamic>> _convertFormsToJson(List<Formulario> forms){
    final List<Map<String, dynamic>> formsAsJson = forms.map<Map<String, dynamic>>(
      (Formulario form)=>form.toJson()
    ).toList();
    return formsAsJson;
  }

  static Future<List<Formulario>> getForms()async{
    final List<Map<String, dynamic>> formsAsJson = await StorageConnectorSingleton.storageConnector.getListResource(formsKey);
    final List<Formulario> forms = _convertJsonFormsToObject(formsAsJson);
    return forms;
  }

  static List<Formulario> _convertJsonFormsToObject(List<Map<String, dynamic>> formsAsJson){
    return formsAsJson.map<Formulario>(
      (Map<String, dynamic> jsonForm) => Formulario.fromJson(jsonForm)
    ).toList();
  }

  static Future<void> removeForms()async{
    await StorageConnectorSingleton.storageConnector.removeResource(formsKey);
  }
}