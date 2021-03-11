import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/errors/services/service_status_err.dart';
import 'package:gap/errors/storage/unfound_storage_element_err.dart';
import 'package:gap/logic/central_manager/data_distributor/data_distributor.dart';
import 'package:gap/logic/central_manager/data_distributor/with_connection/data_distributor_with_connection.dart';
import 'package:gap/logic/central_manager/data_distributor/without_connection/data_distributor_without_connection.dart';
import 'package:gap/logic/central_manager/pages_navigation_manager.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';

class DataDisributorErrorHandlerManager{
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
    if(err.extraInformation == 'refresh_token')
      await _navToLogin();
    else{
      if(lastErrorType != err.runtimeType){
        final String accessToken = await UserStorageManager.getAccessToken();
        await executeFunction(DataDistrFunctionName.UPDATE_ACCESS_TOKEN, accessToken);
      }else
        await _navToLogin();
    }
  }

  void _updateErrorInfo(dynamic err){
    happendError = true;
    lastErrorType = err.runtimeType;
  }

  void _resetErrorInfo(){
    happendError = false;
    lastErrorType = null;
  }

  Future _navToLogin()async{
    await PagesNavigationManager.navToLogin();
  }

  Future _manageUnfoundStorageElementErr(UnfoundStorageElementErr err)async{
    _updateErrorInfo(err);
    if(err.elementType == StorageElementType.AUTH_TOKEN)
      await _navToLogin();
    else{
      if(lastErrorType != err.runtimeType)
        await _navToProjects();
      else
        await _navToLogin();
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
}




class DataDistributorManager{
  static final NetConnectionStateContainer _netConnectionContainer = NetConnectionStateContainer();
  final DataDistributor _dataDistributorWithConnection = DataDistributorWithConnection();
  final DataDistributor _dataDistributorWithoutConnection = SourceDataToBlocWithoutConnection();
  bool happendError;
  int errorRepetitions;

  EnumValues<DataDistrFunctionName, Function> _dataDistributorFunctionsValues;
  Function _lastExecutedFunction;

  final List functionsWithValue = [
    DataDistrFunctionName.UPDATE_ACCESS_TOKEN, 
    DataDistrFunctionName.UPDATE_CHOSEN_PROJECT,
    DataDistrFunctionName.UPDATE_CHOSEN_VISIT, 
    DataDistrFunctionName.UPDATE_CHOSEN_FORM
  ];

  Future executeFunction(DataDistrFunctionName functionName, [dynamic value])async{
    try{
      await _tryExecuteFunction(functionName, value);
    }on ServiceStatusErr catch(err){
      happendError = true;
      
      if(err.extraInformation == 'refresh_token')
        await PagesNavigationManager.navToLogin();
      else{
        //final String accessToken = await UserStorageManager.getAccessToken();
        //await executeFunction(DataDistrFunctionName.UPDATE_ACCESS_TOKEN, accessToken);
        await PagesNavigationManager.navToLogin();
      }
      
    }on UnfoundStorageElementErr catch(err){
      happendError = true;
      if(err.elementType == StorageElementType.AUTH_TOKEN)
        await PagesNavigationManager.navToLogin();
      else
        await PagesNavigationManager.navToProjects();
    }catch(err){
      happendError = true;
      await PagesNavigationManager.navToProjects();
    }
  }

  Future _tryExecuteFunction(DataDistrFunctionName functionName, [dynamic value])async{
    happendError = false;
    _lastExecutedFunction = _dataDistributorFunctionsValues.map[functionName];
    await _executeFunctionByHavingValue(functionName, value);
  }

  Future _executeFunctionByHavingValue(DataDistrFunctionName functionName, [dynamic value])async{
    if(functionsWithValue.contains(functionName))
      await _lastExecutedFunction(value);
    else
      await _lastExecutedFunction();
  }

  //TODO: Quitar función cuando se termine de probar
  Future updateProjects()async{
    try{
      await dataDistributor.updateProjects();
    }on ServiceStatusErr catch(err){
      print(err);
    }catch(err){
      print(err);
    }
  }

  set netConnectionState(NetConnectionState newState){
    _netConnectionContainer.state = newState;
    _initializeDataDistributorFunctionsValues();
  }

  _initializeDataDistributorFunctionsValues(){
    _dataDistributorFunctionsValues =  EnumValues<DataDistrFunctionName, Function>({
      DataDistrFunctionName.UPDATE_ACCESS_TOKEN: dataDistributor.updateAccessToken,
      DataDistrFunctionName.UPDATE_PROJECTS: dataDistributor.updateProjects,
      DataDistrFunctionName.UPDATE_CHOSEN_PROJECT: dataDistributor.updateChosenProject,
      DataDistrFunctionName.UPDATE_VISITS: dataDistributor.updateVisits,
      DataDistrFunctionName.UPDATE_CHOSEN_VISIT: dataDistributor.updateChosenVisit,
      DataDistrFunctionName.UPDATE_FORMULARIOS: dataDistributor.updateFormularios,
      DataDistrFunctionName.UPDATE_CHOSEN_FORM: dataDistributor.updateChosenForm,
      DataDistrFunctionName.END_FORM_FILLING_OUT: dataDistributor.endFormFillingOut,
      DataDistrFunctionName.INIT_FIRST_FIRMER_FILLING_OUT: dataDistributor.initFirstFirmerFillingOut,
      DataDistrFunctionName.INIT_FIRST_FIRMER_FIRM: dataDistributor.initFirstFirmerFirm,
      DataDistrFunctionName.UPDATE_FIRMERS: dataDistributor.updateFirmers,
      DataDistrFunctionName.END_ALL_FORM_PROCESS: dataDistributor.endAllFormProcess,
      DataDistrFunctionName.UPDATE_COMMENTED_IMAGES: dataDistributor.updateCommentedImages,
      DataDistrFunctionName.END_COMMENTED_IMAGES_PROCESS: dataDistributor.endCommentedImagesProcess,
      DataDistrFunctionName.ADD_STORAGE_DATA_TO_INDEX_BLOC: dataDistributor.addStorageDataToIndexBloc,
      DataDistrFunctionName.RESET_CHOSEN_PROJECT: dataDistributor.resetChosenProject,
      DataDistrFunctionName.RESET_VISITS: dataDistributor.resetVisits,
      DataDistrFunctionName.RESET_CHOSEN_VISIT: dataDistributor.resetChosenVisit,
      DataDistrFunctionName.RESET_FORMS: dataDistributor.resetForms,
      DataDistrFunctionName.RESET_CHOSEN_FORM: dataDistributor.resetChosenForm,
      DataDistrFunctionName.RESET_COMMENTED_IMAGES: dataDistributor.resetCommentedImages,
    });
  }

  DataDistributor get dataDistributor{
    if(_netConnectionContainer.state == NetConnectionState.Connected)
      return _dataDistributorWithConnection;
    else
      return _dataDistributorWithoutConnection;
  }
}

class NetConnectionStateContainer{
  NetConnectionState state = NetConnectionState.Disonnected;
}