import 'package:flutter/material.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/ui/pages/adjuntar_fotos_visita_page.dart';
import 'package:gap/ui/pages/firmers/firmers_page.dart';
import 'package:gap/ui/pages/formulario_detail/formulario_detail_page.dart';
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
    NavigationRoute.Init.value : (_)=>InitPage(),
    NavigationRoute.Login.value: (_)=>LoginPage(),
    NavigationRoute.Projects.value: (_)=>ProjectsPage(),
    NavigationRoute.ProjectDetail.value: (_)=>ProjectDetailPage(),
    NavigationRoute.Visits.value: (_)=>VisitsPage(),
    NavigationRoute.VisitDetail.value: (_)=>VisitDetailPage(),
    NavigationRoute.Formularios.value: (_)=>FormulariosPage(),
    NavigationRoute.FormularioDetailForms.value: (_)=>FormularioDetailPage(),
    NavigationRoute.Firmers.value: (_)=>FirmersPage(),
    NavigationRoute.AdjuntarFotosVisita.value: (_)=>AdjuntarFotosVisitaPage(),
  };
}