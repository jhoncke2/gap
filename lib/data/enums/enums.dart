import 'package:gap/logic/storage_managers/source_data_manager.dart';

enum NetConnectionState{
  Connected,
  Disonnected
}

enum DataSource{
  Storage,
  Services
}

enum BlocName{
  UserBloc,
  Projects,
  Visits,
  Formularios,
  ChosenForm,
  Images,
  CommentedImages,
  FirmPaint,
  Index
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


class SourceDadaFunctionTypeWithConnectionStateEnum extends Enum<SrcDataFunctionWithConnState>{
  static const SrcDataFunctionWithConnState _connetedInitValue = SrcDataFunctionWithConnState( SourceDataFunctionType.Init, NetConnectionState.Connected);
  static const SrcDataFunctionWithConnState _connectedUpdateValue = SrcDataFunctionWithConnState( SourceDataFunctionType.SingleUpdate, NetConnectionState.Connected);
  static const SrcDataFunctionWithConnState _disConnectedInitValue = SrcDataFunctionWithConnState( SourceDataFunctionType.Init, NetConnectionState.Disonnected);
  static const SrcDataFunctionWithConnState _disconnectedUpdateValue = SrcDataFunctionWithConnState( SourceDataFunctionType.SingleUpdate, NetConnectionState.Disonnected);

  const SourceDadaFunctionTypeWithConnectionStateEnum(SrcDataFunctionWithConnState value):super(value);

  static const SourceDadaFunctionTypeWithConnectionStateEnum ConnectedInit = const SourceDadaFunctionTypeWithConnectionStateEnum(_connetedInitValue);
  static const SourceDadaFunctionTypeWithConnectionStateEnum ConnectedUpdate = const SourceDadaFunctionTypeWithConnectionStateEnum(_connectedUpdateValue);
  static const SourceDadaFunctionTypeWithConnectionStateEnum DisConnectedInit = const SourceDadaFunctionTypeWithConnectionStateEnum(_disConnectedInitValue);
  static const SourceDadaFunctionTypeWithConnectionStateEnum DisConnectedUpdate = const SourceDadaFunctionTypeWithConnectionStateEnum(_disconnectedUpdateValue);

  factory SourceDadaFunctionTypeWithConnectionStateEnum.fromValue(SrcDataFunctionWithConnState value){
    if(valuesAreEquals(value, ConnectedInit.value))
      return ConnectedInit;
    else if(valuesAreEquals(value, DisConnectedInit.value))
      return DisConnectedInit;
    else if(valuesAreEquals(value, ConnectedUpdate.value))
      return ConnectedUpdate;
    else if(valuesAreEquals(value, DisConnectedUpdate.value))
      return DisConnectedUpdate;
    else
      return ConnectedInit;
  }

  static bool valuesAreEquals(SrcDataFunctionWithConnState v1, SrcDataFunctionWithConnState v2){
    return (v1.connectionState == v2.connectionState && v1.functionType == v2.functionType);
  }
}

class SrcDataFunctionWithConnState{
  final SourceDataFunctionType functionType;
  final NetConnectionState connectionState;
  const SrcDataFunctionWithConnState(
    this.functionType, 
    this.connectionState
  );
}

enum SourceDataFunctionType{
  Init,
  SingleUpdate
}