/**
 * Estructura en el storage:
 *  primer lvl: ids de projectos.
 * segundo lvl: ids de visitas del proyecto
 * tercer lvl: ids de formularios de la visita
 */

final Map<String, dynamic> jsonProjectsIds = {
  '1':{
    '1':['1','2','3'],
    '2':['4','5']
  },
  '2':{
    '3':['6','7'],
    '4':['8','9']
  }
};