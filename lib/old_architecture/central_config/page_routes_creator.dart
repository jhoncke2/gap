import 'package:flutter/material.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/ui/pages/adjuntar_fotos_visita_page.dart';
import 'package:gap/old_architecture/ui/pages/firmers/firmers_page.dart';
import 'package:gap/old_architecture/ui/pages/formulario_detail/formulario_detail_page.dart';
import 'package:gap/old_architecture/ui/pages/formularios_page.dart';
import 'package:gap/old_architecture/ui/pages/init_page.dart';
import 'package:gap/old_architecture/ui/pages/login_page.dart';
import 'package:gap/old_architecture/ui/pages/project_detail_page.dart';
import 'package:gap/old_architecture/ui/pages/projects_page.dart';
import 'package:gap/old_architecture/ui/pages/visit_detail_page.dart';
import 'package:gap/old_architecture/ui/pages/visits_page.dart';

class PageRoutesCreatorOld{
  static final initialRoute = InitPageOld.route;
  static final Map<String, Widget Function(BuildContext)> routes = {
    NavigationRoute.Init.value : (_)=>InitPageOld(),
    NavigationRoute.Login.value: (_)=>LoginPageOld(),
    NavigationRoute.Projects.value: (_)=>ProjectsPageOld(),
    NavigationRoute.ProjectDetail.value: (_)=>ProjectDetailPageOld(),
    NavigationRoute.Visits.value: (_)=>VisitsPageOld(),
    NavigationRoute.VisitDetail.value: (_)=>VisitDetailPageOld(),
    NavigationRoute.Formularios.value: (_)=>FormulariosPageOld(),
    NavigationRoute.FormularioDetail.value: (_)=>FormularioDetailPageOld(),
    NavigationRoute.Firmers.value: (_)=>FirmersPageOld(),
    NavigationRoute.AdjuntarFotosVisita.value: (_)=>AdjuntarFotosVisitaPageOld(),
  };
}