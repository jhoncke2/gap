import 'package:gap/data/enums/enums.dart';
import 'package:gap/logic/central_manager/data_distributor/source_data_to_bloc/source_data_to_bloc.dart';
import 'package:gap/logic/central_manager/data_distributor/source_data_to_bloc/with_connection/data_distributor_with_connection.dart';
import 'package:gap/logic/central_manager/data_distributor/source_data_to_bloc/without_connection/data_distributor_without_connection.dart';

class DataDistributorManager{
  static final NetConnectionStateContainer _netConnectionContainer = NetConnectionStateContainer();
  static final SourceDataToBloc _dataDistributorWithConnection = SourceDataToBlocWithConnection();
  static final SourceDataToBloc _dataDistributorWithoutConnection = SourceDataToBlocWithoutConnection();

  static set netConnectionState(NetConnectionState newState){
    _netConnectionContainer.state = newState;
  }

  static SourceDataToBloc get dataDistributor{
    if(_netConnectionContainer.state == NetConnectionState.Connected)
      return _dataDistributorWithConnection;
    else
      return _dataDistributorWithoutConnection;
  }
}

class NetConnectionStateContainer{
  NetConnectionState state;
}