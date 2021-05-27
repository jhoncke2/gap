import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/old_architecture/logic/central_managers/pages_navigation_manager.dart';
import 'package:gap/old_architecture/ui/pages/formularios_page.dart';
final List<Map<String, dynamic>> navigationItemsParts = [
  {
    'icon':FontAwesomeIcons.longArrowAltRight,
    'name':'Iniciar visita',
    //'nav_function':PagesNavigationManager.navToForms,
    'nav_function': (bool visitHasMuestra, BuildContext context){        

    }
  },
  {
    'icon': Icons.attach_file,
    'name':'Adjuntar fotos',
    'nav_function':PagesNavigationManager.navToCommentedImages,
  },
  {
    'icon': Icons.remove_red_eye,
    'name':'Visualizar visita',
    'navigation_route':FormulariosPageOld.route,
    'nav_function':PagesNavigationManager.navToForms,
  }
];