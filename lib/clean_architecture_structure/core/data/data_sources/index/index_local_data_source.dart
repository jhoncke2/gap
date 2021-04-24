import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/models/index_model.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';

abstract class IndexLocalDataSource{
  Future<void> setIndex(IndexModel index);
  Future<IndexModel> getIndex();
}

class IndexLocalDataSourceImpl implements IndexLocalDataSource{
  static const String indexStorageKey = 'index';
  final StorageConnector storageConnector;

  IndexLocalDataSourceImpl({
    @required this.storageConnector
  });

  @override
  Future<void> setIndex(IndexModel index)async{
    await storageConnector.setMap(index.toJson(), indexStorageKey);
  }

  @override
  Future<IndexModel> getIndex()async{
    final Map<String, dynamic> jsonIndex = await storageConnector.getMap(indexStorageKey);
    return IndexModel.fromJson(jsonIndex);
  }
}