import 'package:gap/clean_architecture_structure/features/login/presentation/pages/login_page.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/pages/muestras_page.dart';
import 'package:gap/clean_architecture_structure/features/projects/presentation/pages/projects_page.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/ui/pages/adjuntar_fotos_visita_page.dart';
import 'package:gap/old_architecture/ui/pages/firmers/firmers_page.dart';
import 'package:gap/old_architecture/ui/pages/formulario_detail/formulario_detail_page.dart';
import 'package:gap/old_architecture/ui/pages/formularios_page.dart';
import 'package:gap/old_architecture/ui/pages/init_page.dart';
import 'package:gap/old_architecture/ui/pages/project_detail_page.dart';
import 'package:gap/old_architecture/ui/pages/visit_detail_page.dart';
import 'package:gap/old_architecture/ui/pages/visits_page.dart';

class PageRoutes{
  static final initialRoute = NavigationRoute.Muestras;
  static final routes = {
    NavigationRoute.Init.value : (_)=>InitPageOld(),
    NavigationRoute.Login.value : (_)=>LoginPage(),
    NavigationRoute.Projects.value : (_)=>ProjectsPage(),
    NavigationRoute.ProjectDetail.value: (_)=>ProjectDetailPageOld(),
    NavigationRoute.Visits.value: (_)=>VisitsPageOld(),
    NavigationRoute.VisitDetail.value: (_)=>VisitDetailPageOld(),
    NavigationRoute.Muestras.value : (_)=>MuestrasPage(),
    NavigationRoute.Formularios.value: (_)=>FormulariosPageOld(),
    NavigationRoute.FormularioDetailForms.value: (_)=>FormularioDetailPageOld(),
    NavigationRoute.Firmers.value: (_)=>FirmersPageOld(),
    NavigationRoute.AdjuntarFotosVisita.value: (_)=>AdjuntarFotosVisitaPageOld(),
  };
}