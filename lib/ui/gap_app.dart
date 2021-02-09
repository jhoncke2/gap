import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/central_config/bloc_providers_creator.dart';
import 'package:gap/central_config/page_routes_creator.dart';

class GapApp extends StatefulWidget {
  @override
  _GapAppState createState() => _GapAppState();
}

class _GapAppState extends State<GapApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: BlocProvidersCreator.blocProviders,
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromRGBO(93, 92, 92, 1),
          secondaryHeaderColor: Colors.brown.withOpacity(0.35)
        ),
        initialRoute: PageRoutesCreator.initialRoute,
        routes: PageRoutesCreator.routes,
      ),
    );
  }
}