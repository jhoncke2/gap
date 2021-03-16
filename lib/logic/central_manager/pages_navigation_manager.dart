import 'package:gap/logic/bloc/nav_routes/custom_navigator.dart';
import 'package:gap/logic/central_manager/data_distributor/data_distributor_error_handler_manager.dart';
import 'package:gap/native_connectors/gps.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/nav_routes/routes_manager.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/ui/utils/dialogs.dart' as dialogs;

class PagesNavigationManager{

  static final gpsActivationRequestMessage = 'Por favor active el servicio ubicación para esta app en configuración del dispositivo para continuar';

  static Future<void> pop()async{
    if(await routesManager.hasPreviousRoute){
      await routesManager.loadRoute();
      final NavigationRoute previousRoute = await routesManager.lastNavRoute;
      await _chooseMethodByDestinationRoute(previousRoute);
      await routesManager.pop();
    }   
  }

  static Future<void> navToLogin()async{
    await _goToInitialPage(NavigationRoute.Login);
  }
  
  static Future<void> navToProjects()async{
    await _updateProjectsData();
    await _goToInitialPage(NavigationRoute.Projects);
  }

  static Future<void> _updateProjectsData()async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_PROJECTS);
  }

  static Future<void> navToProjectDetail(Project project)async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_CHOSEN_PROJECT, project);
    await _goToNextPage(NavigationRoute.ProjectDetail);
  }

  static Future<void> navToVisits()async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_VISITS);
    await _goToNextPage(NavigationRoute.Visits);
  }

  static Future<void> navToVisitDetail(Visit visit)async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_CHOSEN_VISIT, visit);
    await _goToNextPage(NavigationRoute.VisitDetail);
  }

  static Future<void> navToForms()async{
    await _goToNextPage(NavigationRoute.Formularios);
  }

  static Future<void> navToFormDetail(Formulario formulario, BuildContext context)async{
    if(_formularioSePuedeAbrir(formulario)){
      await _GPSValidator.executeMethodByGpsStatus((){_updateForm(formulario);}, _goToAppSetings, gpsActivationRequestMessage);
    } 
  }

  static bool _formularioSePuedeAbrir(Formulario formulario){
    return formulario.formStep != FormStep.Finished && formulario.campos.length > 0;
  }

  static Future _updateForm(Formulario formulario)async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_CHOSEN_FORM, formulario);
    await _goToNextPage(NavigationRoute.FormularioDetailForms);
  }

  static Future _goToAppSetings(BuildContext context, String message)async{
    await dialogs.showErrDialog(context, message);
    await GPS.openAppSettings();
  }

  static Future updateFormFieldsPage()async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_FORM_FIELDS_PAGE);
  }

  static Future initFirstFirmerFillingOut()async{
    await _GPSValidator.executeMethodByGpsStatus(_endFormFillingOut, _goToAppSetings, gpsActivationRequestMessage);
  }

  static Future _endFormFillingOut()async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.END_FORM_FILLING_OUT);
  }

  static Future initFirstFirmerFirm()async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.INIT_FIRST_FIRMER_FIRM);
  }

  static Future<void> addFirmer()async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_FIRMERS);
  }

  static Future<void> endFormFirmers()async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.END_ALL_FORM_PROCESS); 
    await pop();
  }

  static Future<void> navToAdjuntarImages()async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_COMMENTED_IMAGES);
    await _goToNextPage(NavigationRoute.AdjuntarFotosVisita);
  }

  static Future<void> advanceOnAdjuntarImages()async{

  }

  static Future<void> updateImgsToCommentedImgs()async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.ADD_CURRENT_PHOTOS_TO_COMMENTED_IMAGES);
  }

  static Future<void> endAdjuntarImages(BuildContext context)async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.END_COMMENTED_IMAGES_PROCESS);
    await pop();
  }

  static Future<void> _backToProjects()async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.RESET_CHOSEN_PROJECT);
  }

  static Future<void> _backToProjectDetail()async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.RESET_VISITS);
  }

  static Future<void> _backToVisits()async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.RESET_CHOSEN_VISIT);
  }

  static Future<void> _backToVisitDetail()async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.RESET_FORMS);
  }

  static Future<void> _backToForms()async{
    await dataDisributorErrorHandlingManager.executeFunction(DataDistrFunctionName.RESET_CHOSEN_FORM);
  }

  static Future<void> _goToNextPage(NavigationRoute route)async{
    await routesManager.setRoute(route);
  }

  static Future<void> _goToInitialPage(NavigationRoute targetRoute)async{
    await routesManager.replaceAllRoutesForNew(targetRoute);
  }

  static Future<void> _chooseMethodByDestinationRoute(NavigationRoute route)async{
    if(route == NavigationRoute.Projects)
      await _backToProjects();
    else if(route == NavigationRoute.ProjectDetail)
      await _backToProjectDetail();
    else if(route == NavigationRoute.Visits)
      await _backToVisits();
    else if(route == NavigationRoute.VisitDetail)
      await _backToVisitDetail();
    else if(route == NavigationRoute.Formularios)
      await _backToForms();
  }
}

class _GPSValidator{
  static Future executeMethodByGpsStatus(Function methodIfGps, Function methodIfNotGps, String errMessage)async{
    final  gpsStatus = await GPS.gpsPermission;
    switch(gpsStatus){
      case LocationPermission.whileInUse:
        await methodIfGps();
        break;
      case LocationPermission.always:
        await methodIfGps();
        break;
      case LocationPermission.denied:
        await methodIfNotGps(CustomNavigator.navigatorKey.currentContext, errMessage);
        break;
      case LocationPermission.deniedForever:
        await methodIfNotGps(CustomNavigator.navigatorKey.currentContext, errMessage);
        break;
    }
  }
}