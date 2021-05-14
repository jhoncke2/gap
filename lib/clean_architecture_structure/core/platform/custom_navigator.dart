import 'package:flutter/material.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';

abstract class CustomNavigator{
  Future<void> navigateReplacingTo(NavigationRoute navRoute, [dynamic arguments]);
}

class CustomNavigatorImpl implements CustomNavigator{
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  @override
  Future<void> navigateReplacingTo(NavigationRoute navRoute, [dynamic arguments])async{
    await navigatorKey.currentState.pushReplacementNamed(navRoute.value, arguments: arguments);
  }
}