import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/models/index_model.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';

abstract class IndexLocalDataSource{
  Future<void> setIndex(IndexModel index);
  Future<IndexModel> getIndex();
  Future<void> deleteAll();
}

class IndexLocalDataSourceImpl implements IndexLocalDataSource{
  static const String INDEX_STORAGE_KEY = 'index';
  final StorageConnector storageConnector;

  IndexLocalDataSourceImpl({
    @required this.storageConnector
  });

  @override
  Future<void> setIndex(IndexModel index)async{
    await storageConnector.setMap(index.toJson(), INDEX_STORAGE_KEY);
  }

  @override
  Future<IndexModel> getIndex()async{
    final Map<String, dynamic> jsonIndex = await storageConnector.getMap(INDEX_STORAGE_KEY);
    return IndexModel.fromJson(jsonIndex);
  }

  Future<void> deleteAll()async{
    await storageConnector.remove(INDEX_STORAGE_KEY);
  }
}