import 'package:flutter/material.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class ChosenFormStorageManager{
  final String chosenFormKey = 'chosen_form';
  final StorageConnector storageConnector;
  ChosenFormStorageManager():
    this.storageConnector = StorageConnectorSingleton.storageConnector
    ; 

  ChosenFormStorageManager.forTesting({
    @required this.storageConnector
  });

  Future<void> setChosenForm(Formulario form)async{
    final Map<String, dynamic> chosenOneAsJson = form.toJson();
    await storageConnector.setMapResource(chosenFormKey, chosenOneAsJson);
  }

  Future<Formulario> getChosenForm()async{
    final Map<String, dynamic> chosenOneAsJson = await storageConnector.getMapResource(chosenFormKey);
    final Formulario chosenOne = Formulario.fromJson(chosenOneAsJson);
    return chosenOne;
  }

  Future<void> removeChosenForm()async{
    await storageConnector.removeResource(chosenFormKey);
  }
}