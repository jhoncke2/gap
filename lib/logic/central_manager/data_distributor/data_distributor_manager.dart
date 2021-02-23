import 'package:gap/data/enums/enums.dart';
import 'package:gap/logic/central_manager/data_distributor/source_data_to_bloc/data_distributor.dart';
import 'package:gap/logic/central_manager/data_distributor/source_data_to_bloc/with_connection/data_distributor_with_connection.dart';
import 'package:gap/logic/central_manager/data_distributor/source_data_to_bloc/without_connection/data_distributor_without_connection.dart';

class DataDistributorManager{
  static final NetConnectionStateContainer _netConnectionContainer = NetConnectionStateContainer();
  static final DataDistributor _dataDistributorWithConnection = DataDistributorWithConnection();
  static final DataDistributor _dataDistributorWithoutConnection = SourceDataToBlocWithoutConnection();

  static set netConnectionState(NetConnectionState newState){
    _netConnectionContainer.state = newState;
  }

  static DataDistributor get dataDistributor{
    if(_netConnectionContainer.state == NetConnectionState.Connected)
      return _dataDistributorWithConnection;
    else
      return _dataDistributorWithoutConnection;
  }
}

class NetConnectionStateContainer{
  NetConnectionState state;
}