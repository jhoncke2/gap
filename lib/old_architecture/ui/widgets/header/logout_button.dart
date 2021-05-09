import 'package:flutter/material.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';

class LogoutButtonOld extends StatelessWidget {
  const LogoutButtonOld({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return IconButton(
      color: Theme.of(context).primaryColor,
      iconSize: 32,
      icon: Icon(Icons.logout),
      onPressed: () {
        PagesNavigationManager.navToLogin();
      },
    );
        

  }
}
