import 'package:flutter/cupertino.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';

class CustomNavigatorOld{
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static Future navigateReplacingTo(NavigationRoute route)async{
    await navigatorKey.currentState.pushReplacementNamed(route.value);
    /*
    if(navigatorKey.currentState.canPop())
      await navigatorKey.currentState.pushReplacementNamed(route.value);
    else
      navigateTo(route);
    */
  }
/*
  static Future navigateTo(NavigationRoute route)async{
    await navigatorKey.currentState.pushNamed(route.value);
  }
*/
/*
  static Future pop()async{
    navigatorKey.currentState.pop();
  }
*/
}