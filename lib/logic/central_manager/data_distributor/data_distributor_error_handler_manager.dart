import 'package:gap/data/enums/enums.dart';
import 'package:gap/errors/services/service_status_err.dart';
import 'package:gap/errors/storage/unfound_storage_element_err.dart';
import 'package:gap/logic/bloc/nav_routes/custom_navigator.dart';
import 'package:gap/logic/central_manager/data_distributor/data_distributor_manager.dart';
import 'package:gap/logic/central_manager/pages_navigation_manager.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/ui/utils/dialogs.dart' as dialogs;

class DataDisributorErrorHandlerManager{
  final String authenticationErrMessage = 'Ocurrió un problema con la autenticación.';
  final String generalServiceErrMessage = 'Ocurrió un problema con los datos del servidor.';
  final String storageErrMessage = 'Ocurrió un problema con el almacenamiento.';

  final DataDistributorManager dataDistributorManager = DataDistributorManager();
  bool happendError;
  Type lastErrorType;

  Future executeFunction(DataDistrFunctionName functionName, [dynamic value])async{
    try{
      await dataDistributorManager.executeFunction(functionName, value);
    }on ServiceStatusErr catch(err){
      await _manageServiceStatusErr(err);
    }on UnfoundStorageElementErr catch(err){
      await _manageUnfoundStorageElementErr(err);
    }catch(err){
      await _manageGeneralErr(err);
    }
  }

  Future _manageServiceStatusErr(ServiceStatusErr err)async{
    _updateErrorInfo(err);
    if(err.extraInformation == 'refresh_token'){
      await _showDialog(authenticationErrMessage);
      await _navToLogin();
    }
    else{
      if(lastErrorType != err.runtimeType){
        final String accessToken = await UserStorageManager.getAccessToken();
        await executeFunction(DataDistrFunctionName.UPDATE_ACCESS_TOKEN, accessToken);
      }else{
        await _showDialog(generalServiceErrMessage);
        await _navToLogin();
      }
    }
  }

  Future _showDialog(String message)async{
    await dialogs.showTemporalDialog(message);
  }

  void _updateErrorInfo(dynamic err){
    happendError = true;
    lastErrorType = err.runtimeType;
  }

  Future _navToLogin()async{
    await PagesNavigationManager.navToLogin();
  }

  Future _manageUnfoundStorageElementErr(UnfoundStorageElementErr err)async{
    _updateErrorInfo(err);
    if(err.elementType == StorageElementType.AUTH_TOKEN){
      await _showDialog(authenticationErrMessage);
      await _navToLogin();
    }
    else{
      if(lastErrorType != err.runtimeType){
        await _showDialog(storageErrMessage);
        await _navToProjects();
      }  
      else{
        await _showDialog(storageErrMessage);
        await _navToLogin();
      }
    }
  }

  Future _navToProjects()async{
    await PagesNavigationManager.navToProjects();
  }

  Future _manageGeneralErr(err)async{
    _updateErrorInfo(err);
    await _navToProjects();
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