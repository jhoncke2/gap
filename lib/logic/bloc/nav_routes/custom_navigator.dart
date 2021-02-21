import 'package:flutter/cupertino.dart';
import 'package:gap/data/enums/enums.dart';

class CustomNavigator{
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static Future navigateReplacingTo(NavigationRoute route)async{
    await navigatorKey.currentState.pushReplacementNamed(route.value);
  }

  static Future navigateTo(NavigationRoute route)async{
    await navigatorKey.currentState.pushNamed(route.value);
  }

  static Future pop()async{
    navigatorKey.currentState.pop();
  }
}