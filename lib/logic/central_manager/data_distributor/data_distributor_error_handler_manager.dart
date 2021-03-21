import 'package:gap/data/enums/enums.dart';
import 'package:gap/errors/services/service_status_err.dart';
import 'package:gap/errors/storage/unfound_storage_element_err.dart';
import 'package:gap/logic/central_manager/data_distributor/data_distributor_manager.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/ui/utils/dialogs.dart' as dialogs;

class DataDisributorErrorHandlingManager{
  final String authenticationErrMessage = 'Ocurrió un problema con la autenticación.';
  final String generalServiceErrMessage = 'Ocurrió un problema con los datos del servidor.';
  final String storageErrMessage = 'Ocurrió un problema con el almacenamiento.';

  final DataDistributorManager dataDistributorManager = DataDistributorManager();
  bool happendError;
  Type lastErrorType;
  NavigationRoute navigationTodoByError;

  Future executeFunction(DataDistrFunctionName functionName, [dynamic value])async{
    try{
      await _tryExecuteFunction(functionName, value);
    }on ServiceStatusErr catch(err){
      await _manageServiceStatusErr(err, functionName, value);
    }on UnfoundStorageElementErr catch(err){
      await _manageUnfoundStorageElementErr(err);
    }catch(err){
      await _manageGeneralErr(err);
    }
  }

  Future _tryExecuteFunction(DataDistrFunctionName functionName, [dynamic value])async{
    happendError = false;
    await dataDistributorManager.executeFunction(functionName, value);
  }

  Future _manageServiceStatusErr(ServiceStatusErr err, DataDistrFunctionName functionName, dynamic value)async{
    if(err.extraInformation == 'refresh_token'){
      await _manageRefreshTokenErr(err);
    }
    else{
      if(lastErrorType != err.runtimeType){
        await _manageFirstServiceStatusErr(err, functionName, value);
      }else{
        await _manageRepeatedServiceStatusErr(err);
      }
    }
  }

  Future _manageRefreshTokenErr(ServiceStatusErr err)async{
    _updateErrorInfo(err);
    await _showDialog(authenticationErrMessage);
    navigationTodoByError = NavigationRoute.Login;
  }

  Future _manageFirstServiceStatusErr(ServiceStatusErr err, DataDistrFunctionName functionName, dynamic value)async{
    _updateErrorInfo(err);
    final String accessToken = await UserStorageManager.getAccessToken();
    await executeFunction(DataDistrFunctionName.UPDATE_ACCESS_TOKEN, accessToken);
    if(!happendError){
      await executeFunction(functionName, value);
    }
  }

  Future _manageRepeatedServiceStatusErr(ServiceStatusErr err)async{
    _updateErrorInfo(err);
    await _showDialog(generalServiceErrMessage);
    navigationTodoByError = NavigationRoute.Login;
  }

  Future _showDialog(String message)async{
    await dialogs.showTemporalDialog(message);
  }

  void _updateErrorInfo(dynamic err){
    happendError = true;
    lastErrorType = err.runtimeType;
  }

  Future _manageUnfoundStorageElementErr(UnfoundStorageElementErr err)async{
    _updateErrorInfo(err);
    if(err.elementType == StorageElementType.AUTH_TOKEN){
      //await _showDialog(authenticationErrMessage);
      navigationTodoByError = NavigationRoute.Login;
    }
    else{
      if(lastErrorType != err.runtimeType){
        await _showDialog(storageErrMessage);
        navigationTodoByError = NavigationRoute.Projects;
      }  
      else{
        await _showDialog(storageErrMessage);
        navigationTodoByError = NavigationRoute.Login;
      }
    }
  }

  Future _manageGeneralErr(err)async{
    //TODO: Implementar verdaderos Navigatoin Route
    if(lastErrorType != err.runtimeType)
      navigationTodoByError = null;
    else
      navigationTodoByError = null;
    _updateErrorInfo(err);
  }

  set netConnectionState(NetConnectionState newState){
    dataDistributorManager.netConnectionState = newState;
    _resetErrorInfo();
  }

  void _resetErrorInfo(){
    happendError = false;
    lastErrorType = null;
  }
}

final DataDisributorErrorHandlingManager dataDisributorErrorHandlingManager = DataDisributorErrorHandlingManager();