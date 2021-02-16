import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class IndexStorageManager{

  static final String indexConfigKey = 'index';

  static Future<void> setIndex(IndexState indexConfig)async{
    final Map<String, dynamic> indexConfigAsJson = _convertIndexToJson(indexConfig);
    await StorageConnectorSingleton.storageConnector.setMapResource(indexConfigKey, indexConfigAsJson);
  }

  static Map<String, dynamic> _convertIndexToJson(IndexState indexConfig){
    final Map<String, dynamic> indexConfigAsJson = {
      'current_index': indexConfig.currentIndexPage,
      'n_pages':indexConfig.nPages,
      'se_puede_avanzar':indexConfig.sePuedeAvanzar,
      'se_puede_retroceder':indexConfig.sePuedeRetroceder,
    };
    return indexConfigAsJson;
  }

  static Future<IndexState> getIndex()async{
    final Map<String, dynamic> indexConfigAsJson = await StorageConnectorSingleton.storageConnector.getMapResource(indexConfigKey);
    final IndexState indexConfig = _convertJsonIndexToObject(indexConfigAsJson);
    return indexConfig;
  }

  static IndexState _convertJsonIndexToObject(Map<String, dynamic> indexConfigAsJson){
    if(indexConfigAsJson.isEmpty){
      return IndexState();
    }else{
      return IndexState.fromJson(indexConfigAsJson);
    }
  }

  static Future<void> removeIndex()async{
    await StorageConnectorSingleton.storageConnector.removeResource(indexConfigKey);
  }
}