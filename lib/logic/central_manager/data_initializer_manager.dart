import 'package:bloc/bloc.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/logic/bloc/nav_routes/routes_manager.dart';
import 'package:gap/logic/central_manager/preloaded_storage_to_services_manager.dart';
import 'package:gap/logic/storage_managers/source_data_manager.dart';

class DataInitializerManager{
  static final RoutesManager routesManager = RoutesManager();
  static final SourceDataToBlocManager _storageRecentActivityBlocManager = SourceDataWithConnectionManager();
  static final SourceDataToBlocManager _storagePreloadedDataBlocManager = SourceDataWithoutConnectionManager();

  static final Map<BlocName, Bloc> _blocs = {};

  static set blocs(Map<BlocName, Bloc> blocs){
    //TODO: Set blocs to datasourcesManagers
    blocs.forEach((blocName, bloc) {
      _blocs[blocName] = bloc;
    });
  }

  static Future<void> changeDataSourceFromConnectionState(NetConnectionState connectionState)async{
    
    SourceDataManager.restartAppData(connectionState);
    /*
    switch(connectionState){
      case NetConnectionState.Connected:
        _manageDataWithConnection(routes);
        break;
      case NetConnectionState.Disonnected:
        _manageDataWithoutConnection(routes);
        break;
    }*/
  }

  static void _manageDataWithConnection(List<NavigationRoute> routes){
    
     PreloadedStorageToServicesManager.sendPreloadedStorageDataToServices();
    //TODO: Uso de services para enviar los preloaded formularios completados
  }

  static void _manageDataWithoutConnection(List<NavigationRoute> routes){
  }
}