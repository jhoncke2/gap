import 'package:bloc/bloc.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/logic/storage_managers/storage_manager.dart';

class DataSourceManager{
  static final StorageBlocsManager _storageRecentActivityBlocManager = StorageRecentActivityBlocsManager();
  static final StorageBlocsManager _storagePreloadedDataBlocManager = StoragePreloadedDataBlocsManager();

  static final Map<BlocName, Bloc> _blocs = {};

  static set blocs(Map<BlocName, Bloc> blocs){
    blocs.forEach((blocName, bloc) {
      _blocs[blocName] = bloc;
    });
  }

  static void changeDataSourceFromConnectionState(NetConnectionState connectionState){
    switch(connectionState){
      case NetConnectionState.Connected:
        _manageDataWithConnection();
        break;
      case NetConnectionState.Disonnected:
        _manageDataWithoutConnection();
        break;
    }
  }

  static void _manageDataWithConnection(){
    _storageRecentActivityBlocManager.addStorageDataToBlocs(_blocs);
    //TODO: Uso de services para enviar los preloaded formularios completados
  }

  static void _manageDataWithoutConnection(){
    _storagePreloadedDataBlocManager.addStorageDataToBlocs(_blocs);
  }

}