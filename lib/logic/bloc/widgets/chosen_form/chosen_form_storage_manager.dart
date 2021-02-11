import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class ChosenFormStorageManager{
  static final String chosenFormKey = 'chosen_form';
  final StorageConnector storageConnector;
  ChosenFormStorageManager():
    this.storageConnector = StorageConnectorSingleton.storageConnector
    ; 


  static Future<void> setChosenForm(Formulario form)async{
    final Map<String, dynamic> chosenOneAsJson = form.toJson();
    await StorageConnectorSingleton.storageConnector.setMapResource(chosenFormKey, chosenOneAsJson);
  }

  static Future<Formulario> getChosenForm()async{
    final Map<String, dynamic> chosenOneAsJson = await StorageConnectorSingleton.storageConnector.getMapResource(chosenFormKey);
    final Formulario chosenOne = Formulario.fromJson(chosenOneAsJson);
    return chosenOne;
  }

  static Future<void> removeChosenForm()async{
    await StorageConnectorSingleton.storageConnector.removeResource(chosenFormKey);
  }
}