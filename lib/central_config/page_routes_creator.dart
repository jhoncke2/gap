import 'package:flutter/material.dart';
import 'package:gap/ui/pages/adjuntar_fotos_visita_page.dart';
import 'package:gap/ui/pages/formulario_detail_page.dart';
import 'package:gap/ui/pages/formularios_page.dart';
import 'package:gap/ui/pages/init_page.dart';
import 'package:gap/ui/pages/login_page.dart';
import 'package:gap/ui/pages/project_detail_page.dart';
import 'package:gap/ui/pages/projects_page.dart';
import 'package:gap/ui/pages/visit_detail_page.dart';
import 'package:gap/ui/pages/visits_page.dart';

class PageRoutesCreator{

  static final initialRoute = InitPage.route;
  static final Map<String, Widget Function(BuildContext)> routes = {
    InitPage.route: (_)=>InitPage(),
    LoginPage.route: (_)=>LoginPage(),
    ProjectsPage.route: (_)=>ProjectsPage(),
    ProjectDetailPage.route: (_)=>ProjectDetailPage(),
    VisitsPage.route: (_)=>VisitsPage(),
    VisitDetailPage.route: (_)=>VisitDetailPage(),
    FormulariosPage.route: (_)=>FormulariosPage(),
    FormularioDetailPage.route: (_)=>FormularioDetailPage(),
    AdjuntarFotosVisitaPage.route: (_)=>AdjuntarFotosVisitaPage(),
  };
  
}