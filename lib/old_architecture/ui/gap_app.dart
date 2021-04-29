import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/old_architecture/central_config/bloc_providers_creator.dart';
import 'package:gap/old_architecture/central_config/page_routes_creator.dart';
import 'package:gap/old_architecture/logic/bloc/nav_routes/custom_navigator.dart';
import 'package:gap/old_architecture/ui/pages/init_page.dart';

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
      navigatorKey: CustomNavigator.navigatorKey,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(93, 92, 92, 1),
        secondaryHeaderColor: Colors.brown.withOpacity(0.35)
      ),
      home: InitPage(),
      routes: PageRoutesCreator.routes,
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