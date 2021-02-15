import 'package:flutter/material.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/native_connectors/storage_connector.dart';

class IndexStorageManager{
  final String indexConfigKey = 'index';
  final StorageConnector storageConnector;
  
  IndexStorageManager():
    this.storageConnector = StorageConnectorSingleton.storageConnector
    ;
  
  IndexStorageManager.forTesting({
    @required this.storageConnector
  });

  Future<void> setIndexConfig(IndexState indexConfig)async{
    final Map<String, dynamic> indexConfigAsJson = _convertCommentedImagesToJson(indexConfig);
    await storageConnector.setMapResource(indexConfigKey, indexConfigAsJson);
  }

  Map<String, dynamic> _convertCommentedImagesToJson(IndexState indexConfig){
    final Map<String, dynamic> indexConfigAsJson = {
      'current_index': indexConfig.currentIndexPage,
      'n_pages':indexConfig.nPages,
      'se_puede_avanzar':indexConfig.sePuedeAvanzar,
      'se_puede_retroceder':indexConfig.sePuedeRetroceder,
    };
    return indexConfigAsJson;
  }

  Future<IndexState> getIndexConfig()async{
    final Map<String, dynamic> indexConfigAsJson = await storageConnector.getMapResource(indexConfigKey);
    final IndexState indexConfig = _convertJsonCommentedImagesToObject(indexConfigAsJson);
    return indexConfig;
  }

  IndexState _convertJsonCommentedImagesToObject(Map<String, dynamic> indexConfigAsJson){
    final IndexState indexConfig = IndexState(
      nPages: indexConfigAsJson['n_pages'],
      currentIndexPage: indexConfigAsJson['current_index'],
      sePuedeAvanzar: indexConfigAsJson['se_puede_avanzar'],
      sePuedeRetroceder: indexConfigAsJson['se_puede_retroceder']
    );
    return indexConfig;
  }

  Future<void> removeCommentedImages()async{
    await storageConnector.removeResource(indexConfigKey);
  }
}