import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/old_architecture/logic/central_managers/data_distributor/data_distributor.dart';
import 'package:gap/old_architecture/logic/storage_managers/user/user_storage_manager.dart';

class SourceDataToBlocWithoutConnection extends DataDistributor{
  
  @override
  Future doInitialConfig()async{
    final String accessToken = await UserStorageManager.getAccessToken();
    _updateAccessToken(accessToken);
  }

  void _updateAccessToken(String accessToken){
    final UserOldBloc uBloc = DataDistributor.blocsAsMap[BlocName.User];
    uBloc.add(SetAccessToken(accessToken: accessToken));
  }

  @override
  Future resetChosenVisit()async{
  }
}