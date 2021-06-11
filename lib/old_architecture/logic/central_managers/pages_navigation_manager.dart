import 'package:flutter/cupertino.dart';
import 'package:gap/old_architecture/native_connectors/permissions.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/navigation/navigation_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
import 'package:gap/old_architecture/logic/central_managers/data_distributor/data_distributor_error_handler_manager.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/ui/utils/dialogs.dart' as dialogs;
import 'package:permission_handler/permission_handler.dart';

class PagesNavigationManager{

  static final gpsActivationRequestMessage = 'Por favor active el servicio ubicación para esta app en configuración del dispositivo';
  static final CustomNavigator customNavigator = sl();
  static final NavigationRepository navRepository = sl();
  static final NavigationLocalDataSource navLocalDataSource = sl();


  static Future<void> pop()async{
    final List<NavigationRoute> navRoutes = await navLocalDataSource.getNavRoutes();
    if(navRoutes.length > 1){
      await _chooseMethodByCurrentBackingRoute(navRoutes.last);
      await _chooseMethodByDestinationRoute(navRoutes[navRoutes.length - 2]);
      await navLocalDataSource.removeLast();
      await customNavigator.navigateReplacingTo((await navLocalDataSource.getNavRoutes()).last);
    }
  }

  static Future<void> navToLogin()async{
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.LOGOUT);
    await _goToInitialPage(NavigationRoute.Login);
  }
  
  
  static Future<void> navToProjects(Map<String, dynamic> loginInfo)async{
    await _login(loginInfo);
    if(!dataDisrtibutorErrorHandlingManager.happendError){
      await _updateProjectsData();
    }
    await _goToPageByHavingOrNotError(NavigationRoute.Projects, true);
  }
  

  static Future _login(Map<String, dynamic> loginInfo)async{
    loginInfo['type'] = 'first_login';
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.LOGIN, loginInfo);
  }

  static Future<void> _updateProjectsData()async{
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_PROJECTS);
  }

  static Future<void> navToProjectDetail(ProjectOld project)async{
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_CHOSEN_PROJECT, project);
    await _goToPageByHavingOrNotError(NavigationRoute.ProjectDetail, false);
  }

  static Future<void> navToVisits()async{
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_VISITS);
    await _goToPageByHavingOrNotError(NavigationRoute.Visits, false);
  }

  static Future<void> navToVisitDetail(VisitOld visit)async{
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_CHOSEN_VISIT, visit);
    await _goToPageByHavingOrNotError(NavigationRoute.VisitDetail, false);
  }

  static Future<void> navToMuestras()async{
    await _goToPageByHavingOrNotError(NavigationRoute.Muestras, false);
  }

  static Future<void> navToForms()async{
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_FORMULARIOS);
    await _goToNextPage(NavigationRoute.Formularios);
  }

  static Future<void> navToFormDetail(FormularioOld formulario, BuildContext context)async{
    await _executeMethodByValidateStorage(()async{
      if(await _formularioSePuedeAbrir(formulario)){
        await _GPSValidator.executeMethodByGpsStatus((){_updateForm(formulario);}, _goToAppSetings, gpsActivationRequestMessage);
      }
    });
    
  }

  static Future<bool> _formularioSePuedeAbrir(FormularioOld formulario)async{
    bool isEmpty = formulario.campos.isEmpty;
    //if(isEmpty)
      //await dialogs.showTemporalDialog('Formulario sin campos');
    //return !formulario.completo && !isEmpty;
    //return !isEmpty;
    return true;
  }

  static Future _updateForm(FormularioOld formulario)async{
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_CHOSEN_FORM, formulario);
    await _goToPageByHavingOrNotError(NavigationRoute.FormularioDetail, false);
  }

  static Future _goToAppSetings(BuildContext context, String message)async{
    //await dialogs.showErrDialog(context, message);
    await dialogs.showTemporalDialog(message);
    //await GPS.openAppSettings();
  }

  static Future updateFormFieldsPage()async{
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_FORM_FIELDS_PAGE);
  }

  static Future endFormFillingOut()async{
    await _executeMethodByValidateStorage(()async{
      await _GPSValidator.executeMethodByGpsStatus(_endFormFillingOut, _goToAppSetings, gpsActivationRequestMessage);
    });
  }

  static Future _endFormFillingOut()async{
    await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.END_FORM_FILLING_OUT);
    //await _goToPageByHavingOrNotError(NavigationRoute.Firmers, false);
  }

  static Future initFirstFirmerFillingOut()async{
    await _executeMethodByValidateStorage(()async{
      await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.INIT_FIRST_FIRMER_FILLING_OUT);
      await _goToPageByHavingOrNotError(NavigationRoute.Firmers, false);
    });
    
  }

  static Future initFirstFirmerFirm()async{
    await _executeMethodByValidateStorage(()async{
      await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.INIT_FIRST_FIRMER_FIRM);
    });
    
  }

  static Future<void> addFirmer()async{
    await _executeMethodByValidateStorage(()async{
      await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_FIRMERS);
    });
    
  }

  static Future<void> endFormFirmers()async{
    await _executeMethodByValidateStorage(()async{
      await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.END_ALL_FORM_PROCESS); 
      await _backToForms();
      await navLocalDataSource.removeLast();
      await navLocalDataSource.removeLast();
      await customNavigator.navigateReplacingTo((await navLocalDataSource.getNavRoutes()).last);
    }); 
  }

  static Future<void> endForms()async{
    await _executeMethodByValidateStorage(()async{
      await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.RESET_FORMS);
      await navLocalDataSource.removeLast();
      await navLocalDataSource.removeLast();
      await customNavigator.navigateReplacingTo((await navLocalDataSource.getNavRoutes()).last);
    }); 
  }

  static Future<void> navToCommentedImages()async{ 
    await _executeMethodByValidateStorage(()async{
      await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.UPDATE_COMMENTED_IMAGES);
      await _goToPageByHavingOrNotError(NavigationRoute.AdjuntarFotosVisita, false);
    });
  }

  static Future<void> updateImgsToCommentedImgs()async{
    await _executeMethodByValidateStorage(()async{
      await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.ADD_CURRENT_PHOTOS_TO_COMMENTED_IMAGES);
    });
  }

  static Future<void> endAdjuntarImages(BuildContext context)async{
    //await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.END_COMMENTED_IMAGES_PROCESS);
    await pop();
  }

  static Future<void> _backToProjects()async{
    await _executeMethodByValidateStorage(()async{
      await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.RESET_CHOSEN_PROJECT);
    });
  }

  static Future<void> _backToProjectDetail()async{
    await _executeMethodByValidateStorage(()async{
      await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.RESET_VISITS);
    });
  }

  static Future<void> _backToVisits()async{
    await _executeMethodByValidateStorage(()async{
      await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.RESET_CHOSEN_VISIT);
    });
  }

  static Future<void> _backToVisitDetail()async{
  }

  static Future<void> _backToForms()async{
    await _executeMethodByValidateStorage(()async{
      await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.RESET_CHOSEN_FORM);
    });
  }

  static Future _goToPageByHavingOrNotError(NavigationRoute destinationRoute, bool replacingAllRoutes)async{
    if(dataDisrtibutorErrorHandlingManager.happendError){
      if(dataDisrtibutorErrorHandlingManager.navigationTodoByError != null) 
        await _goToInitialPage(dataDisrtibutorErrorHandlingManager.navigationTodoByError??NavigationRoute.Login);
    }
    else
      await _goToPage(destinationRoute, replacingAllRoutes);
  }

  static Future _goToPage(NavigationRoute route, bool replacingAllRoutes)async{
    if(replacingAllRoutes)
      await _goToInitialPage(route);
    else
      await _goToNextPage(route);
  }

  static Future<void> _goToNextPage(NavigationRoute route)async{
    await navRepository.setNavRoute(route);
    await customNavigator.navigateReplacingTo(route);
  }

  static Future<void> _goToInitialPage(NavigationRoute targetRoute)async{
    await navRepository.replaceAllNavRoutesForNew(targetRoute);
    await customNavigator.navigateReplacingTo(targetRoute);
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
    else if(route == NavigationRoute.Firmers)
      await _backToForms();
  }

  static Future _chooseMethodByCurrentBackingRoute(NavigationRoute route)async{
    if(route == NavigationRoute.AdjuntarFotosVisita)
      await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.END_COMMENTED_IMAGES_PROCESS);
    if(route == NavigationRoute.Formularios)
      await dataDisrtibutorErrorHandlingManager.executeFunction(DataDistrFunctionName.RESET_FORMS);
  }

  static Future _executeMethodByValidateStorage(Function methodIfStorage)async{
    final PermissionStatus storagePermission = await NativeServicesPermissions.storageServiceStatus;
    if(storagePermission.isGranted)
      await methodIfStorage();
  }
}

class _GPSValidator{
  static Future executeMethodByGpsStatus(Function methodIfGps, Function methodIfNotGps, String errMessage)async{
    final PermissionStatus gpsPermission = await NativeServicesPermissions.gpsServiceStatus;
    if(gpsPermission.isGranted)
      await methodIfGps();
    else
      await methodIfNotGps();
    /*
    final  gpsStatus = await GPS.gpsPermission;
    switch(gpsStatus){
      case LocationPermission.whileInUse:
        await methodIfGps();
        break;
      case LocationPermission.always:
        await methodIfGps();
        break;
      case LocationPermission.denied:
        await methodIfNotGps(CustomNavigatorImpl.navigatorKey.currentContext, errMessage);
        break;
      case LocationPermission.deniedForever:
        await methodIfNotGps(CustomNavigatorImpl.navigatorKey.currentContext, errMessage);
        break;
    }
    */
  }
}

class _StorageValidator{
  static Future executeMethodbyStorageStatus(Function methodIfStorage)async{

  }
}