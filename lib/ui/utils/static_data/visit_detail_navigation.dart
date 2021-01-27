import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/ui/pages/adjuntar_fotos_visita_page.dart';
import 'package:gap/ui/pages/formularios_page.dart';
final List<Map<String, dynamic>> navigationItemsParts = [
  {
    'icon':FontAwesomeIcons.longArrowAltRight,
    'name':'Iniciar visita',
    'navigation_route':FormulariosPage.route,
  },
  {
    'icon': Icons.attach_file,
    'name':'Adjuntar fotos',
    'navigation_route':AdjuntarFotosVisitaPage.route,
  },
  {
    'icon': Icons.remove_red_eye_outlined,
    'name':'Visualizar visita',
    'navigation_route':FormulariosPage.route,
  }
];