import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class FormulariosStorageManager{
  final String formsKey = 'formularios';
  final StorageConnector storageConnector;
  FormulariosStorageManager():
    this.storageConnector = StorageConnectorSingleton.storageConnector
    ; 

  FormulariosStorageManager.forTesting({
    @required this.storageConnector
  });

  Future<void> setForms(List<Formulario> forms)async{
    final List<Map<String, dynamic>> formsAsJson = _convertFormsToJson(forms);
    await storageConnector.setListResource(formsKey, formsAsJson);
  }

  List<Map<String, dynamic>> _convertFormsToJson(List<Formulario> forms){
    final List<Map<String, dynamic>> formsAsJson = forms.map<Map<String, dynamic>>(
      (Formulario form)=>form.toJson()
    ).toList();
    return formsAsJson;
  }

  Future<List<Formulario>> getForms()async{
    final List<Map<String, dynamic>> formsAsJson = await storageConnector.getListResource(formsKey);
    final List<Formulario> forms = _convertJsonFormsToObject(formsAsJson);
    return forms;
  }

  List<Formulario> _convertJsonFormsToObject(List<Map<String, dynamic>> formsAsJson){
    return formsAsJson.map<Formulario>(
      (Map<String, dynamic> jsonForm) => Formulario.fromJson(jsonForm)
    ).toList();
  }

  Future<void> removeForms()async{
    await storageConnector.removeResource(formsKey);
  }
}