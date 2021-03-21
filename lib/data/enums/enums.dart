enum NetConnectionState{
  Connected,
  Disonnected
}

enum DataSource{
  Storage,
  Services
}

enum BlocName{
  User,
  Projects,
  Visits,
  Formularios,
  ChosenForm,
  Images,
  CommentedImages,
  FirmPaint,
  Index,
  VisitsSingleton
}

abstract class Enum<T>{
  final T value;
  const Enum(this.value);
}

class ProcessStage extends Enum<String>{

  const ProcessStage(String value): super(value);

  static const ProcessStage Pendiente = const ProcessStage('pendiente');
  static const ProcessStage EnProceso = const ProcessStage('en_proceso');
  static const ProcessStage Realizada = const ProcessStage('realizada');

  factory ProcessStage.fromValue(String value){
    if(value == Pendiente.value)
      return Pendiente;
    else if(value == EnProceso.value)
      return EnProceso;
    else if(value == Realizada.value)
      return Realizada;
    else{
      //TODO: ¿Una excepción?
      return Pendiente;
    }
      
  }
}

abstract class NavRouteEnum extends Enum<String>{
  final String step;
  const NavRouteEnum(String route, {this.step}) : super(route);
}

class NavigationRoute extends NavRouteEnum{
  const NavigationRoute(String value, {String step}) : super(value, step: step);
  
  static const NavigationRoute Init = const NavigationRoute('init');
  static const NavigationRoute Login = const NavigationRoute('login');
  static const NavigationRoute Projects = const NavigationRoute('projects');
  static const NavigationRoute ProjectDetail = const NavigationRoute('project_detail');
  static const NavigationRoute Visits = const NavigationRoute('visits');
  static const NavigationRoute VisitDetail = const NavigationRoute('visit_detail');
  static const NavigationRoute Formularios = const NavigationRoute('formularios');
  static const NavigationRoute FormularioDetailForms = const NavigationRoute('formulario_detail', step: 'forms');
  static const NavigationRoute FormularioDetailFirmers = const NavigationRoute('formulario_detail', step: 'firmers');
  static const NavigationRoute AdjuntarFotosVisita = const NavigationRoute('adjuntar_fotos_visit');

  factory NavigationRoute.fromJson(Map<String, dynamic> json){
    final String jsonRoute = json['route'];
    if(jsonRoute == Login.value){
      return Login;
    }else if(jsonRoute == Projects.value){
      return Projects;
    }else if(jsonRoute == ProjectDetail.value){
      return ProjectDetail;
    }else if(jsonRoute == Visits.value){
      return Visits;
    }else if(jsonRoute == VisitDetail.value){
      return VisitDetail;
    }else if(jsonRoute == Formularios.value){
      return Formularios;
    }else if(jsonRoute == FormularioDetailForms.value){
      return _getExactFormularioDetailRoute(json['step']);
    }else if(jsonRoute == AdjuntarFotosVisita.value){
      return AdjuntarFotosVisita;
    }else
      return Init;
  }

  static NavigationRoute _getExactFormularioDetailRoute(String step){
    if(step == FormularioDetailForms.step){
      return FormularioDetailForms;
    }else{
      return FormularioDetailFirmers;
    }
  }
}


class DistributionProcessDeterminant extends Enum<DataDistrFunctionWithConnState>{
  static const DataDistrFunctionWithConnState _connetedInitValue = DataDistrFunctionWithConnState( DataDistributorFunction.AppUpdate, NetConnectionState.Connected);
  static const DataDistrFunctionWithConnState _connectedUpdateValue = DataDistrFunctionWithConnState( DataDistributorFunction.SingleUpdate, NetConnectionState.Connected);
  static const DataDistrFunctionWithConnState _disConnectedInitValue = DataDistrFunctionWithConnState( DataDistributorFunction.AppUpdate, NetConnectionState.Disonnected);
  static const DataDistrFunctionWithConnState _disconnectedUpdateValue = DataDistrFunctionWithConnState( DataDistributorFunction.SingleUpdate, NetConnectionState.Disonnected);

  const DistributionProcessDeterminant(DataDistrFunctionWithConnState value):super(value);

  static const DistributionProcessDeterminant ConnectedAppUpdate = const DistributionProcessDeterminant(_connetedInitValue);
  static const DistributionProcessDeterminant ConnectedSingleUpdate = const DistributionProcessDeterminant(_connectedUpdateValue);
  static const DistributionProcessDeterminant DisConnectedAppUpdate = const DistributionProcessDeterminant(_disConnectedInitValue);
  static const DistributionProcessDeterminant DisConnectedSingleUpdate = const DistributionProcessDeterminant(_disconnectedUpdateValue);

  factory DistributionProcessDeterminant.fromValue(DataDistrFunctionWithConnState value){
    if(valuesAreEquals(value, ConnectedAppUpdate.value))
      return ConnectedAppUpdate;
    else if(valuesAreEquals(value, DisConnectedAppUpdate.value))
      return DisConnectedAppUpdate;
    else if(valuesAreEquals(value, ConnectedSingleUpdate.value))
      return ConnectedSingleUpdate;
    else if(valuesAreEquals(value, DisConnectedSingleUpdate.value))
      return DisConnectedSingleUpdate;
    else
      return ConnectedAppUpdate;
  }

  static bool valuesAreEquals(DataDistrFunctionWithConnState v1, DataDistrFunctionWithConnState v2){
    return (v1.connectionState == v2.connectionState && v1.functionType == v2.functionType);
  }
}

class DataDistrFunctionWithConnState{
  final DataDistributorFunction functionType;
  final NetConnectionState connectionState;
  const DataDistrFunctionWithConnState(
    this.functionType, 
    this.connectionState
  );
}

enum DataDistributorFunction{
  AppUpdate,
  SingleUpdate
}


class InputType extends Enum<String>{
  const InputType(String value): super(value);

  static const InputType TextField = InputType('input');
  static const InputType Select = InputType('select');
}

enum DataDistrFunctionName{
  DO_INITIAL_CONFIG,
  LOGIN,
  UPDATE_ACCESS_TOKEN,
  UPDATE_PROJECTS,
  UPDATE_CHOSEN_PROJECT,
  UPDATE_VISITS,
  UPDATE_CHOSEN_VISIT,
  UPDATE_FORMULARIOS,
  UPDATE_CHOSEN_FORM,
  UPDATE_FORM_FIELDS_PAGE,
  END_FORM_FILLING_OUT,
  INIT_FIRST_FIRMER_FILLING_OUT,
  INIT_FIRST_FIRMER_FIRM,
  UPDATE_FIRMERS,
  END_ALL_FORM_PROCESS,
  UPDATE_COMMENTED_IMAGES,
  ADD_CURRENT_PHOTOS_TO_COMMENTED_IMAGES,
  END_COMMENTED_IMAGES_PROCESS,
  ADD_STORAGE_DATA_TO_INDEX_BLOC,
  RESET_CHOSEN_PROJECT,
  RESET_VISITS,
  RESET_CHOSEN_VISIT,
  RESET_FORMS,
  RESET_CHOSEN_FORM,
  RESET_COMMENTED_IMAGES
}