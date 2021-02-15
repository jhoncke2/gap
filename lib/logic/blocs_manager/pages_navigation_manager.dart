import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/bloc/nav_routes/nav_routes_manager.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/native_connectors/net_connection_detector.dart';
import 'package:gap/data/fake_data/fake_data.dart' as fakeData;

class PagesNavigationManager{
  
  static Future<void> navToProjects(BuildContext context)async{
    if(await _thereIsNetConnection())
      _loadProjectsFromServices(context);
    //TODO: evaluación de authToken
    _goToInitialPage(NavigationRoute.Projects, context);
  }

  static Future<bool> _thereIsNetConnection()async{
    return await NetConnectionDetector.netConnectionState == NetConnectionState.Connected;
  }

  static void _loadProjectsFromServices(BuildContext context){
    //TODO: Uso de services
    final ProjectsBloc projBloc = BlocProvider.of<ProjectsBloc>(context);
    final List<Project> projects = fakeData.projects;
    final SetProjects setProjecsEvent = SetProjects(projects: projects);
    projBloc.add(setProjecsEvent);
  }

  static Future<void> navToProjectDetail(Project project, BuildContext context)async{
    _updateChosenProject(project, context);
    _goToNextPage(NavigationRoute.ProjectDetail, context);
  }

  static void _updateChosenProject(Project project, BuildContext context){
    final ProjectsBloc projectsBloc = BlocProvider.of<ProjectsBloc>(context);
    final ChooseProject cpEvent = ChooseProject(chosenOne: project);
    projectsBloc.add(cpEvent);
  }

  static Future<void> navToVisits(BuildContext context)async{
    if(await _thereIsNetConnection())
      _loadVisitsFromServices(context);
    _goToNextPage(NavigationRoute.Visits, context);
  }

  static void _loadVisitsFromServices(BuildContext context){
    //TODO: get visits from services
    final VisitsBloc visitsBloc = BlocProvider.of<VisitsBloc>(context);
    final List<Visit> visits = fakeData.visits;
    final SetVisits svEvent = SetVisits(visits: visits);
    visitsBloc.add(svEvent);
  }

  static Future<void> navToVisitDetail(Visit visit, BuildContext context)async{
    _updateVisitDetail(visit, context);
    if(await _thereIsNetConnection())
      _loadFormsFromServices(context);
    _goToNextPage(NavigationRoute.VisitDetail, context);
  }

  static void _updateVisitDetail(Visit visit, BuildContext context){
    final VisitsBloc visitsBloc = BlocProvider.of<VisitsBloc>(context);
    final ChooseVisit svEvent = ChooseVisit(chosenOne: visit);
    visitsBloc.add(svEvent);
  }

  static void _loadFormsFromServices(BuildContext context){
    //TODO: Implementar get from services
    final FormulariosBloc formsBloc = BlocProvider.of<FormulariosBloc>(context);
    final SetForms setFormsEvent = SetForms(forms: fakeData.formularios);
    formsBloc.add(setFormsEvent);
  }

  static Future<void> navToForms(BuildContext context)async{
    _goToNextPage(NavigationRoute.Formularios, context);
  }

  static Future<void> navToFormDetail(Formulario form, BuildContext context)async{
    _updateChosenForm(form, context);
    _goToNextPage(NavigationRoute.FormularioDetailForms, context);
  }

  static void _updateChosenForm(Formulario formulario, BuildContext context){
    //TODO: Implementar get de información completa from services ??
    final FormulariosBloc formsBloc = BlocProvider.of<FormulariosBloc>(context);
    final ChooseForm chooseFormEvent = ChooseForm(chosenOne: formulario);
    formsBloc.add(chooseFormEvent);
    final ChosenFormBloc chosenFormBloc = BlocProvider.of<ChosenFormBloc>(context);
    final InitFormFillingOut iffoEvent = InitFormFillingOut(formulario: formulario);
    chosenFormBloc.add(iffoEvent);
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
    navRoutesManager.setRoute(route);
    Navigator.of(context).pushNamed(route.value);
  }

  static Future<void> _goToPageAfterPopping(NavigationRoute targetRoute, int nPops, BuildContext context)async{
    await navRoutesManager.setRouteAfterPopping(targetRoute, nPops);
    Navigator.of(context).popUntil((route) => route.settings.name == targetRoute.value);
  }

  static void _goToInitialPage(NavigationRoute targetRoute, BuildContext context){
    navRoutesManager.replaceAllRoutesForNew(targetRoute);
    Navigator.of(context).pushReplacementNamed(targetRoute.value);
  }

}