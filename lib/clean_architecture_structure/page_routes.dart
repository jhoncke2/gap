import 'package:gap/clean_architecture_structure/features/init/presentation/pages/init_page.dart';
import 'package:gap/clean_architecture_structure/features/login/presentation/pages/login_page.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/pages/muestras_page.dart';
import 'package:gap/clean_architecture_structure/features/projects/presentation/pages/project_detail_page.dart';
import 'package:gap/clean_architecture_structure/features/projects/presentation/pages/projects_page.dart';
import 'package:gap/clean_architecture_structure/features/visits/presentation/pages/visit_detail_page.dart';
import 'package:gap/clean_architecture_structure/features/visits/presentation/pages/visits_page.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/ui/pages/adjuntar_fotos_visita_page.dart';
import 'package:gap/old_architecture/ui/pages/firmers/firmers_page.dart';
import 'package:gap/old_architecture/ui/pages/formulario_detail/formulario_detail_page.dart';
import 'package:gap/old_architecture/ui/pages/formularios_page.dart';
import 'package:gap/old_architecture/ui/pages/init_page.dart';

class PageRoutes{
  static final initialRoute = NavigationRoute.Init;
  static final routes = {
    //NavigationRoute.Init.value : (_)=>InitPageOld(),
    NavigationRoute.Init.value: (_)=>InitPage(),
    NavigationRoute.Login.value : (_)=>LoginPage(),
    //NavigationRoute.Login.value : (_)=>LoginPageOld(),
    NavigationRoute.Projects.value : (_)=>ProjectsPage(),
    //NavigationRoute.Projects.value : (_)=>ProjectsPageOld(),
    NavigationRoute.ProjectDetail.value: (_)=> ProjectDetailPage(),
    //NavigationRoute.ProjectDetail.value: (_)=> ProjectDetailPageOld(),
    //NavigationRoute.Visits.value: (_)=>VisitsPageOld(),
    NavigationRoute.Visits.value: (_)=>VisitsPage(),
    //NavigationRoute.VisitDetail.value: (_)=>VisitDetailPageOld(),
    NavigationRoute.VisitDetail.value: (_)=>VisitDetailPage(),
    NavigationRoute.Muestras.value : (_)=>MuestrasPage(),
    NavigationRoute.Formularios.value: (_)=>FormulariosPageOld(),
    NavigationRoute.FormularioDetail.value: (_)=>FormularioDetailPageOld(),
    NavigationRoute.Firmers.value: (_)=>FirmersPageOld(),
    NavigationRoute.AdjuntarFotosVisita.value: (_)=>AdjuntarFotosVisitaPageOld(),
  };
}