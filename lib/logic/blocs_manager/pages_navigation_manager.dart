import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/nav_routes/routes_manager.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/logic/central_manager/data_distributor/data_distributor.dart';

class PagesNavigationManager{

  static Future<void> pop(BuildContext context)async{
    Navigator.of(context).pop();
    await routesManager.pop();
    final NavigationRoute newRoute = routesManager.currentRoute;
    await _chooseMethodByRoute(newRoute);
  }
  
  static Future<void> navToProjects(BuildContext context)async{
    await _updateProjectsData();
    _goToInitialPage(NavigationRoute.Projects, context);
  }

  static Future<void> _updateProjectsData()async{
    await DataDistributor.updateBlocData(NavigationRoute.Projects);
  }

  static Future<void> navToProjectDetail(Project project, BuildContext context)async{
    DataDistributor.updateBlocData(NavigationRoute.ProjectDetail, project);
    //_updateChosenProject(project, context);
    _goToNextPage(NavigationRoute.ProjectDetail, context);
  }

  static Future<void> navToVisits(BuildContext context)async{
    await _updateVisitsData();     
    _goToNextPage(NavigationRoute.Visits, context);
  }

  static Future<void> _updateVisitsData()async{
    await DataDistributor.updateBlocData(NavigationRoute.Visits);
  }

  static Future<void> navToVisitDetail(Visit visit, BuildContext context)async{
    await DataDistributor.updateBlocData(NavigationRoute.VisitDetail, visit);
    await DataDistributor.updateBlocData(NavigationRoute.Formularios);
    _goToNextPage(NavigationRoute.VisitDetail, context);
  }

  static Future<void> navToForms(BuildContext context)async{
    _goToNextPage(NavigationRoute.Formularios, context);
  }

  static Future<void> navToFormDetail(Formulario formulario, BuildContext context)async{
    await DataDistributor.updateBlocData(NavigationRoute.FormularioDetailForms, formulario);
    //_updateChosenForm(formulario, context);
    _goToNextPage(NavigationRoute.FormularioDetailForms, context);
  }

  static Future<void> endFormFirmers(BuildContext context)async{    
    await _addFirmToFirmer();
    //TODO: El service de enviar formulario Firmers (si hay internet)
    ChosenFormManagerSingleton.chosenFormManager.finishFirms();
    pop(context);
  }

  static Future<void> _addFirmToFirmer()async{
    await ChosenFormManagerSingleton.chosenFormManager.addFirmToFirmer();
  }

  static Future<void> navToAdjuntarImages(BuildContext context)async{
    _goToNextPage(NavigationRoute.AdjuntarFotosVisita, context);
  }

  static Future<void> endAdjuntarImages(BuildContext context)async{
    //TODO: Service de enviar imágenes (si hay internet o guardar en el storage)
    final CommentedImagesBloc commImgsBloc = BlocProvider.of<CommentedImagesBloc>(context);
    commImgsBloc.add(ResetCommentedImages());
    final IndexBloc indexBloc = BlocProvider.of<IndexBloc>(context);
    indexBloc.add(ResetAllOfIndex());
    await _goToPageAfterPopping(NavigationRoute.VisitDetail, 1, context);
  }

  static void _goToNextPage(NavigationRoute route, BuildContext context){
    routesManager.setRoute(route);
    Navigator.of(context).pushNamed(route.value);
  }

  static Future<void> _goToPageAfterPopping(NavigationRoute targetRoute, int nPops, BuildContext context)async{
    await routesManager.setRouteAfterPopping(targetRoute, nPops);
    Navigator.of(context).popUntil((route) => route.settings.name == targetRoute.value);
  }

  static void _goToInitialPage(NavigationRoute targetRoute, BuildContext context){
    routesManager.replaceAllRoutesForNew(targetRoute);
    Navigator.of(context).pushReplacementNamed(targetRoute.value);
  }

  static Future<void> _chooseMethodByRoute(NavigationRoute route)async{
    if(route == NavigationRoute.Projects)
      await _updateProjectsData();
    else if(route == NavigationRoute.Visits)
      await _updateVisitsData();
  }
}