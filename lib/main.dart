import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/images/images_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/firm_paint/firm_paint_bloc.dart';
import 'package:gap/logic/bloc/widgets/form_inputs_navigation/form_inputs_navigation_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/ui/pages/adjuntar_fotos_visita_page.dart';
import 'package:gap/ui/pages/formulario_detail_page.dart';
import 'package:gap/ui/pages/formularios_page.dart';
import 'package:gap/ui/pages/init_page.dart';
import 'package:gap/ui/pages/login_page.dart';
import 'package:gap/ui/pages/painter_test_page.dart';
import 'package:gap/ui/pages/project_detail_page.dart';
import 'package:gap/ui/pages/projects_page.dart';
import 'package:gap/ui/pages/visit_detail_page.dart';
import 'package:gap/ui/pages/visits_page.dart';
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProjectsBloc>(create: (_)=>ProjectsBloc()),
        BlocProvider<VisitsBloc>(create: (_)=>VisitsBloc()),
        BlocProvider<FormulariosBloc>(create: (_)=>FormulariosBloc()),
        BlocProvider<ChosenFormBloc>(create: (_)=>ChosenFormBloc()),
        BlocProvider<FormInputsNavigationBloc>(create: (_)=>FormInputsNavigationBloc()),
        BlocProvider<ImagesBloc>(create: (_)=>ImagesBloc()),
        BlocProvider<CommentedImagesBloc>(create: (_)=>CommentedImagesBloc()),
        BlocProvider<IndexBloc>(create: (_)=>IndexBloc()),
        BlocProvider<FirmPaintBloc>(create: (_)=>FirmPaintBloc())
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromRGBO(93, 92, 92, 1),
          secondaryHeaderColor: Colors.brown.withOpacity(0.35)
        ),
        initialRoute: PainterTestPage.route,
        routes: {
          InitPage.route: (_)=>InitPage(),
          LoginPage.route: (_)=>LoginPage(),
          ProjectsPage.route: (_)=>ProjectsPage(),
          ProjectDetailPage.route: (_)=>ProjectDetailPage(),
          VisitsPage.route: (_)=>VisitsPage(),
          VisitDetailPage.route: (_)=>VisitDetailPage(),
          FormulariosPage.route: (_)=>FormulariosPage(),
          FormularioDetailPage.route: (_)=>FormularioDetailPage(),
          AdjuntarFotosVisitaPage.route: (_)=>AdjuntarFotosVisitaPage(),
          //For test
          PainterTestPage.route: (_)=>PainterTestPage()
        },
      ),
    );
  }
}