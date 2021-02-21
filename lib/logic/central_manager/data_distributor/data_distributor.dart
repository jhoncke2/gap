
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/central_manager/data_distributor/source_data_to_bloc/source_data_to_bloc.dart';
import 'package:gap/logic/bloc/nav_routes/routes_manager.dart';
import 'package:gap/logic/central_manager/data_distributor/source_data_to_bloc/with_connection/data_distributor_with_connection.dart';
import 'package:gap/logic/central_manager/data_distributor/source_data_to_bloc/without_connection/data_distributor_without_connection.dart';
import 'package:gap/native_connectors/net_connection_detector.dart';

class DataDistributor{
  static final SourceDataToBloc srcDataToBlocWithConnectionInitializer = SourceDataToBlocWithConnectionInitializer();
  static final SourceDataToBloc srcDataToBlocWithConnectionUpdater = SourceDataToBlocWithConnectionUpdater();
  static final SourceDataToBloc srcDataToBlocWithoutConnection = SourceDataToBlocWithoutConnection();

  // _SourceDataWithConnectionInitializerManager
  // _SourceDataWithConnectionUpdaterManager

  static Future<void> updateAppData(NetConnectionState netConnectionState)async{
    final DistributionProcessDeterminant srcDataFunctionTypeWithConnectionStateEnum = _defineProcessDeterminantByParams(DataDistributorFunction.AppUpdate, netConnectionState);
    await _executeFunctionByParams(srcDataFunctionTypeWithConnectionStateEnum);
  }

  static Future<void> updateBlocData(NavigationRoute route, [Entity entityToAdd])async{
    final NetConnectionState netConnectionState = await NetConnectionDetector.netConnectionState;
    final DistributionProcessDeterminant srcDataFunctionTypeWithConnectionStateEnum = _defineProcessDeterminantByParams(DataDistributorFunction.SingleUpdate, netConnectionState);
    await _executeFunctionByParams(srcDataFunctionTypeWithConnectionStateEnum, route, entityToAdd);
  }

  static DistributionProcessDeterminant _defineProcessDeterminantByParams(DataDistributorFunction sdft, NetConnectionState netConnectionState){
    final DataDistrFunctionWithConnState srcDataFunctionWithConnState = DataDistrFunctionWithConnState(
      sdft,
      netConnectionState
    );
    return DistributionProcessDeterminant.fromValue(srcDataFunctionWithConnState);
  }

  static Future<void> _executeFunctionByParams(DistributionProcessDeterminant srcDataFunctionWithConnStateEnum, [NavigationRoute route, Entity entityToAdd])async{
    switch(srcDataFunctionWithConnStateEnum){
      case DistributionProcessDeterminant.ConnectedAppUpdate:
        _addDataToBlocsByNavRoutes(srcDataToBlocWithConnectionInitializer);
        break;
      case DistributionProcessDeterminant.ConnectedSingleUpdate:
        srcDataToBlocWithConnectionUpdater.addDataToBlocByNavRoute(route, entityToAdd);
        break;
      case DistributionProcessDeterminant.DisConnectedAppUpdate:
        _addDataToBlocsByNavRoutes(srcDataToBlocWithoutConnection);
        break;
      case DistributionProcessDeterminant.DisConnectedSingleUpdate:
        srcDataToBlocWithoutConnection.addDataToBlocByNavRoute(route);
        break;
    }
  }

  static Future<void> _addDataToBlocsByNavRoutes(SourceDataToBloc sdbManager)async{
    final List<NavigationRoute> routes = await routesManager.routesTree;
    sdbManager.addDataToBlocsByNavRoutes(routes);
  }
}
