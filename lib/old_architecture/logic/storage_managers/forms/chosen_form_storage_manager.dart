import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/native_connectors/storage_connector.dart';

class ChosenFormStorageManager{
  static final String _chosenFormKey = 'chosen_form';
  final StorageConnectorOld storageConnector;
  ChosenFormStorageManager():
    this.storageConnector = StorageConnectorOldSingleton.storageConnector
    ; 


  static Future<void> setChosenForm(FormularioOld form)async{
    final Map<String, dynamic> chosenOneAsJson = form.toJson();
    await StorageConnectorOldSingleton.storageConnector.setMapResource(_chosenFormKey, chosenOneAsJson);
  }

  static Future<FormularioOld> getChosenForm()async{
    final Map<String, dynamic> chosenOneAsJson = await StorageConnectorOldSingleton.storageConnector.getMapResource(_chosenFormKey);
    final FormularioOld chosenOne = FormularioOld.fromJson(chosenOneAsJson);
    return chosenOne;
  }

  static Future<void> removeChosenForm()async{
    await StorageConnectorOldSingleton.storageConnector.removeResource(_chosenFormKey);
  }
}