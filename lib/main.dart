import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/entities/images/images_bloc.dart';
import 'package:gap/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/bloc/widgets/commented_images_widgets/commented_images_widgets_bloc.dart';
import 'package:gap/bloc/widgets/form_inputs_navigation/form_inputs_navigation_bloc.dart';
import 'package:gap/bloc/widgets/index/index_bloc.dart';
import 'package:gap/pages/adjuntar_fotos_visita_page.dart';
import 'bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/pages/formulario_detail_page.dart';
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
        BlocProvider<ProjectsBloc>(create: (_)=>ProjectsBloc()),
        BlocProvider<VisitsBloc>(create: (_)=>VisitsBloc()),
        BlocProvider<FormulariosBloc>(create: (_)=>FormulariosBloc()),
        BlocProvider<FormInputsNavigationBloc>(create: (_)=>FormInputsNavigationBloc()),
        BlocProvider<ImagesBloc>(create: (_)=>ImagesBloc()),
        BlocProvider<CommentedImagesWidgetsBloc>(create: (_)=>CommentedImagesWidgetsBloc()),
        BlocProvider<IndexBloc>(create: (_)=>IndexBloc()),
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromRGBO(93, 92, 92, 1),
          secondaryHeaderColor: Colors.brown.withOpacity(0.35)
        ),
        initialRoute: LoginPage.route,
        routes: {
          LoginPage.route: (_)=>LoginPage(),
          ProjectsPage.route: (_)=>ProjectsPage(),
          ProjectDetailPage.route: (_)=>ProjectDetailPage(),
          VisitsPage.route: (_)=>VisitsPage(),
          VisitDetailPage.route: (_)=>VisitDetailPage(),
          FormulariosPage.route: (_)=>FormulariosPage(),
          FormularioDetailPage.route: (_)=>FormularioDetailPage(),
          AdjuntarFotosVisitaPage.route: (_)=>AdjuntarFotosVisitaPage()
        },
      ),
    );
  }
}