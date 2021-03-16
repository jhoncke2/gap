import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/central_manager/data_distributor/data_distributor.dart';
import 'package:gap/logic/central_manager/data_distributor/with_connection/data_distributor_with_connection.dart';
import 'package:gap/logic/central_manager/data_distributor/without_connection/data_distributor_without_connection.dart';

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
      DataDistrFunctionName.UPDATE_FORM_FIELDS_PAGE: dataDistributor.updateFormFieldsPage,
      DataDistrFunctionName.END_FORM_FILLING_OUT: dataDistributor.endFormFillingOut,
      DataDistrFunctionName.INIT_FIRST_FIRMER_FILLING_OUT: dataDistributor.initFirstFirmerFillingOut,
      DataDistrFunctionName.INIT_FIRST_FIRMER_FIRM: dataDistributor.initFirstFirmerFirm,
      DataDistrFunctionName.UPDATE_FIRMERS: dataDistributor.updateFirmers,
      DataDistrFunctionName.END_ALL_FORM_PROCESS: dataDistributor.endAllFormProcess,
      DataDistrFunctionName.UPDATE_COMMENTED_IMAGES: dataDistributor.updateCommentedImages,
      DataDistrFunctionName.ADD_CURRENT_PHOTOS_TO_COMMENTED_IMAGES: dataDistributor.addCurrentPhotosToCommentedImages,
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