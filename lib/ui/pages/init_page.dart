import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/logic/blocs_manager/commented_images_index_manager.dart';
import 'package:gap/logic/bloc/nav_routes/nav_routes_manager.dart';
import 'package:gap/ui/utils/size_utils.dart';
class InitPage extends StatelessWidget with WidgetsBindingObserver{
  static final route = 'init';
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    _addPostFrameCallBack();
    return Scaffold(
      body: Container(),
    );
  }

  void _addPostFrameCallBack(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      _validateInitialConfiguration();
      _navigateToFirstPage();
    });
  }

  void _validateInitialConfiguration(){
    _initSizeUtils();
    initBlocsManagers();
  }

  void _initSizeUtils(){
    final SizeUtils sizeUtils = SizeUtils();
    final Size screenSize = MediaQuery.of(_context).size;
    sizeUtils.initUtil(screenSize);
  }

  void initBlocsManagers(){
    CommentedImagesIndexManagerSingleton(appContext: _context);
    ChosenFormManagerSingleton(appContext: _context);
  }

  void _navigateToFirstPage(){
    final NavigationRoute initialRoute = navRoutesManager.currentRoute;
    final UserBloc userBloc = BlocProvider.of<UserBloc>(_context);
    final String authToken = userBloc.state.authToken;
    if([initialRoute, authToken].contains(null))
      _goToLogin();
    else
      _goToLoggedPage(initialRoute);
  }

  void _goToLogin(){
    final NavigationRoute loginRoute = NavigationRoute.Login;
    navRoutesManager.replaceAllRoutesForNew(loginRoute);
    Navigator.of(_context).pushReplacementNamed(loginRoute.value);
  }

  void _goToLoggedPage(NavigationRoute route){
    Navigator.of(_context).pushReplacementNamed(route.value);
  }
}