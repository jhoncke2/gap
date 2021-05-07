import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/platform/custom_navigator.dart';
import 'package:gap/clean_architecture_structure/core/utils/page_routes.dart';
import 'package:gap/clean_architecture_structure/features/login/presentation/pages/login_page.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/pages/muestras_page.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';
import 'package:gap/old_architecture/central_config/bloc_providers_creator.dart';
import 'package:gap/old_architecture/central_config/page_routes_creator.dart';
import 'package:gap/old_architecture/logic/bloc/nav_routes/custom_navigator.dart';
import 'package:gap/old_architecture/ui/pages/init_page.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

// ignore: must_be_immutable
class GapApp extends StatefulWidget {
  _GapAppState state = _GapAppState();

  @override
  _GapAppState createState() => state;
}

class _GapAppState extends State<GapApp> with WidgetsBindingObserver{
  Function didChangeAppLifecycleStateMethod;
  Function didChangeDependenciesMethod;
  MaterialApp app;
  @override
  Widget build(BuildContext context) {
    app = _createMaterialApp(context);
    return WillPopScope(
      onWillPop: _onBackButton,
      child: MultiBlocProvider(
        providers: BlocProvidersCreator.blocProviders,
        child: _createMaterialApp(context),
      ),
    );
  }

  Future<bool> _onBackButton()async{
    return false;
  }

  MaterialApp _createMaterialApp(BuildContext context){
    return MaterialApp(
      title: 'GAP',
      debugShowCheckedModeBanner: false,
      //navigatorKey: CustomNavigatorOld.navigatorKey,
      navigatorKey: CustomNavigatorImpl.navigatorKey,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(93, 92, 92, 1),
        secondaryHeaderColor: Colors.brown.withOpacity(0.35)
      ),
      //home: InitPage(),
      home: MuestrasPage(),
      //routes: PageRoutesCreatorOld.routes,
      routes: PageRoutes.routes,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    didChangeAppLifecycleStateMethod(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    didChangeDependenciesMethod();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}