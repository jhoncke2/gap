import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/logic/blocs_manager/pages_navigation_manager.dart';
import 'package:gap/ui/pages/formularios_page.dart';
final List<Map<String, dynamic>> navigationItemsParts = [
  {
    'icon':FontAwesomeIcons.longArrowAltRight,
    'name':'Iniciar visita',
    'nav_function':PagesNavigationManager.navToForms,
  },
  {
    'icon': Icons.attach_file,
    'name':'Adjuntar fotos',
    'nav_function':PagesNavigationManager.navToAdjuntarImages,
  },
  {
    'icon': Icons.remove_red_eye_outlined,
    'name':'Visualizar visita',
    'navigation_route':FormulariosPage.route,
    'nav_function':PagesNavigationManager.navToForms,
  }
];