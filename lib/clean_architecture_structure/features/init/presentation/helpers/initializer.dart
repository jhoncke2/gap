import 'package:flutter/material.dart';
import 'package:gap/clean_architecture_structure/core/domain/repositories/navigation_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_replacing_all_to.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/navigation/go_to.dart';
import 'package:gap/clean_architecture_structure/core/domain/use_cases/use_case.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:gap/clean_architecture_structure/core/platform/native_services_permission.dart';
import 'package:gap/clean_architecture_structure/features/init/domain/use_cases/get_app_already_runned.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';

class Initializer {
  final CustomNavigator customNavigator;
  final NativeServicesPermissions servicesPermissions;
  final GetAppAlreadyRunned getAppAlreadyRunned;
  final GoReplacingAllTo goReplacingAllTo;
    //TODO: Quitar cuando esté implementado todo el proyecto en clean architecture
  final NavigationRepository navRepository;
  

  Initializer({
    @required this.customNavigator, 
    @required this.servicesPermissions,
    @required this.goReplacingAllTo,
    @required this.getAppAlreadyRunned,
    @required this.navRepository
  });

  Future init()async{
    final storageIsGranted = await servicesPermissions.storageIsGranted;
    if(storageIsGranted)
      await _evaluateAppAlreadyRunned();
    else{
      final gpsStatus = await servicesPermissions.storageRequestStatus;
      if(gpsStatus == PlatformPermissionStatus.GRANTED)
        await _evaluateAppAlreadyRunned();
    }
  }

  Future _evaluateAppAlreadyRunned()async{
    final appAlreadyRunned = await getAppAlreadyRunned(NoParams());
    await appAlreadyRunned.fold((l){

    }, (alreadyRunned)async{
      if(alreadyRunned){
        await _navToExistingRoute();
      }else
        await _navToLogin();
    });
  }

  Future _navToLogin()async{
    await goReplacingAllTo(NavigationParams(navRoute: NavigationRoute.Login));
    customNavigator.navigateReplacingTo(NavigationRoute.Login);
  }

  Future _navToExistingRoute()async{
    final currentRoute = await navRepository.getCurrentRoute();
    await currentRoute.fold((l)async{
      await _navToLogin();
    }, (route)async{
      await customNavigator.navigateReplacingTo(route);
    });
    
  }
}