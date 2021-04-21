import 'package:gap/old_architecture/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/old_architecture/native_connectors/storage_connector.dart';

class IndexStorageManager{

  static final String _indexConfigKey = 'index';

  static Future<void> setIndex(IndexState indexConfig)async{
    final Map<String, dynamic> indexConfigAsJson = _convertIndexToJson(indexConfig);
    await StorageConnectorOldSingleton.storageConnector.setMapResource(_indexConfigKey, indexConfigAsJson);
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
    final Map<String, dynamic> indexConfigAsJson = await StorageConnectorOldSingleton.storageConnector.getMapResource(_indexConfigKey);
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
    await StorageConnectorOldSingleton.storageConnector.removeResource(_indexConfigKey);
  }
}