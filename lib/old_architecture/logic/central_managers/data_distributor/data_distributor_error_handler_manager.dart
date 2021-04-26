import 'package:flutter/services.dart';
import 'package:gap/old_architecture/central_config/bloc_providers_creator.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/errors/services/service_status_err.dart';
import 'package:gap/old_architecture/errors/storage/app_never_runned.dart';
import 'package:gap/old_architecture/errors/storage/unfound_storage_element_err.dart';
import 'package:gap/old_architecture/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/old_architecture/logic/central_managers/data_distributor/data_distributor_manager.dart';
import 'package:gap/old_architecture/native_connectors/storage_connector.dart';
import 'package:gap/old_architecture/ui/utils/dialogs.dart' as dialogs;

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
    }on AppNeverRunnedErr{
      await _manageAppNeverRunnedErr();
    }on ServiceStatusErr catch(err){
      await _manageServiceStatusErr(err, functionName, value);
    }on UnfoundStorageElementErr catch(err){
      await _manageUnfoundStorageElementErr(err);
    }on PlatformException catch(exception){
      await _managePlatformException(exception, functionName, value);
    }catch(err){
      await _manageGeneralErr(err);
    }
  }

  Future _tryExecuteFunction(DataDistrFunctionName functionName, [dynamic value])async{
    happendError = false;
    await dataDistributorManager.executeFunction(functionName, value);
  }

  Future _manageAppNeverRunnedErr()async{
    happendError = true;
    navigationTodoByError = NavigationRoute.Login;
  }

  Future _manageServiceStatusErr(ServiceStatusErr err, DataDistrFunctionName functionName, dynamic value)async{
    if(err.extraInformation == 'login'){
      await _manageLoginErr(err, value);
    }else if(err.extraInformation == 'refresh_token'){
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

  Future _manageLoginErr(ServiceStatusErr err, Map<String, dynamic> loginInfo)async{
    _updateErrorInfo(err);
    if(loginInfo['type'] == 'first_login'){
      BlocProvidersCreator.userBloc.add(ChangeLoginButtopnAvaibleless(isAvaible: true));
      await _showDialog(err.message);
      navigationTodoByError = null;
    }else{
      navigationTodoByError = NavigationRoute.Login;
    }
  }

  Future _manageRefreshTokenErr(ServiceStatusErr err)async{
    _updateErrorInfo(err);
    await _executeReloadingLogin();
  }

  Future _manageFirstServiceStatusErr(ServiceStatusErr err, DataDistrFunctionName functionName, dynamic value)async{
    _updateErrorInfo(err);
    //final String accessToken = await UserStorageManager.getAccessToken();
    //await executeFunction(DataDistrFunctionName.UPDATE_ACCESS_TOKEN, accessToken);
    await _executeReloadingLogin();
    if(!happendError){
      await executeFunction(functionName, value);
      lastErrorType = null;
    }
  }
  
  Future _executeReloadingLogin()async{
    await executeFunction(DataDistrFunctionName.LOGIN, {'type':'reloading_login'});
  }

  Future _manageRepeatedServiceStatusErr(ServiceStatusErr err)async{
    _updateErrorInfo(err);
    await _showDialog(generalServiceErrMessage);
    navigationTodoByError = NavigationRoute.Login;
    lastErrorType = null;
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
      lastErrorType = null;
    }
    else{
      if(lastErrorType != err.runtimeType){
        await _showDialog(storageErrMessage);
        navigationTodoByError = NavigationRoute.Projects;
        lastErrorType = null;
      }  
      else{
        await _showDialog(storageErrMessage);
        navigationTodoByError = NavigationRoute.Login;
        lastErrorType = null;
      }
    }
  }

  Future _managePlatformException(PlatformException exception, DataDistrFunctionName functionName, dynamic value)async{
    if(lastErrorType != exception.runtimeType){
      await StorageConnectorOldSingleton.storageConnector.deleteAll();
      await executeFunction(functionName, value);
    }else{
      happendError = true;
      lastErrorType = exception.runtimeType;
      navigationTodoByError = NavigationRoute.Login;
      await StorageConnectorOldSingleton.storageConnector.deleteAll();
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

final DataDisributorErrorHandlingManager dataDisrtibutorErrorHandlingManager = DataDisributorErrorHandlingManager();