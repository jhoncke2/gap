import 'package:gap/clean_architecture_structure/features/login/presentation/pages/login_page.dart';
import 'package:gap/clean_architecture_structure/features/muestras/presentation/pages/muestras_page.dart';
import 'package:gap/clean_architecture_structure/features/projects/presentation/pages/projects_page.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';

class PageRoutes{
  static final initialRoute = NavigationRoute.Muestras;
  static final routes = {
    NavigationRoute.Login.value : (_)=>LoginPage(),
    NavigationRoute.Projects.value : (_)=>ProjectsPage(),
    NavigationRoute.Muestras.value : (_)=>MuestrasPage()
  };
}