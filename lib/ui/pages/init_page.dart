import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/logic/blocs_manager/commented_images_index_manager.dart';
import 'package:gap/logic/bloc/nav_routes/routes_manager.dart';
import 'package:gap/logic/central_manager/data_initializer.dart';
import 'package:gap/native_connectors/net_connection_detector.dart';
import 'package:gap/ui/utils/size_utils.dart';

// ignore: must_be_immutable
class InitPage extends StatelessWidget{

  static final String route = 'init';
  static StreamController<BuildContext> _contextStreamController = StreamController();
  static Stream<BuildContext> get contextStream => _contextStreamController.stream;
  bool _alreadyInit = false;
  BuildContext _context;

  @override
  Widget build(BuildContext context){
    _doInitialConfig(context);
    return Scaffold(
      body: BlocBuilder<UserBloc, UserState>(
        builder: (_, state){
          return _AuthTokenWaiter(userState: state);
        },
      ),
    );
  }

  void _doInitialConfig(BuildContext context){
    _context = context;
    _initSizeUtils(context);
    _initBlocsManagers(context);
    _callBackAfterBuildIfAlreadyInit(context);
    
  }

  void _initBlocsManagers(BuildContext context){
    CommentedImagesIndexManagerSingleton(appContext: context);
    ChosenFormManagerSingleton(appContext: context);
  }
  
  void _initSizeUtils(context){
    final Size screenSize = MediaQuery.of(context).size;
    SizeUtils sizeUtils = SizeUtils();
    sizeUtils.initUtil(screenSize);
  }

  void _callBackAfterBuildIfAlreadyInit(BuildContext context){
    if(!_alreadyInit){
      _alreadyInit = true;
      _callBackAfterBuild(context);
    }
  }

  void _callBackAfterBuild(BuildContext context){
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      await _setOnConnectionChange();
      await _initDataInitialization();
    });
  }

  Future _setOnConnectionChange()async{
    await NetConnectionDetector.initCurrentNavConnectionState();
    NetConnectionDetector.onConnectionChange = _onConnectionChanged;
  }

  Future _onConnectionChanged(NetConnectionState newConnState)async{
    await dataInitializer.init(_context, newConnState);
  }

  Future _initDataInitialization()async{
    final NetConnectionState netConnectionState = await NetConnectionDetector.netConnectionState;
    await dataInitializer.init(_context, netConnectionState);
  }
}

// ignore: must_be_immutable
class _AuthTokenWaiter extends StatelessWidget {
  
  final UserState userState;
  BuildContext _context;

  _AuthTokenWaiter({
    @required this.userState
  });

  @override
  Widget build(BuildContext context) {
    _initContext(context);
    //_callBackAfterBuild();
    return Container();
  }

  void _initContext(BuildContext context){
    _context = context;
  }

  void _callBackAfterBuild(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      _doValidationsIfAuthTokenIsLoaded();
    });
  }

  void _doValidationsIfAuthTokenIsLoaded(){  
    if(userState.authTokenIsLoaded)
      _doValidations();  
  }

  void _doValidations(){
    _validateInitialConfiguration();
    _navigateToFirstPage();
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
    final NavigationRoute initialRoute = routesManager.currentRoute;
    if([initialRoute, userState.authToken].contains(null))
      _goToLogin();
    else
      _goToLoggedPage(initialRoute);
  }

  void _goToLogin(){
    final NavigationRoute loginRoute = NavigationRoute.Login;
    routesManager.replaceAllRoutesForNew(loginRoute);
    Navigator.of(_context).pushReplacementNamed(loginRoute.value);
  }

  void _goToLoggedPage(NavigationRoute route)async{
    final List<NavigationRoute> routesTree = await routesManager.routesTree;
    routesTree.forEach((NavigationRoute route) {
      Navigator.of(_context).pushNamed(route.value);
    });
  }
}