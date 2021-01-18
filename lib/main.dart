import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/formularios/formularios_bloc.dart';
import 'package:gap/bloc/visits/visits_bloc.dart';
import 'package:gap/pages/formularios_page.dart';
import 'package:gap/pages/login_page.dart';
import 'package:gap/pages/project_detail_page.dart';
import 'package:gap/pages/projects_page.dart';
import 'package:gap/pages/visit_detail_page.dart';
import 'package:gap/pages/visits_page.dart';
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VisitsBloc>(create: (_)=>VisitsBloc()),
        BlocProvider<FormulariosBloc>(create: (_)=>FormulariosBloc())
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromRGBO(93, 92, 92, 1)
        ),
        initialRoute: LoginPage.route,
        routes: {
          LoginPage.route: (_)=>LoginPage(),
          ProjectsPage.route: (_)=>ProjectsPage(),
          ProjectDetailPage.route: (_)=>ProjectDetailPage(),
          VisitsPage.route: (_)=>VisitsPage(),
          VisitDetailPage.route: (_)=>VisitDetailPage(),
          FormulariosPage.route: (_)=>FormulariosPage()
        },
      ),
    );
  }
}