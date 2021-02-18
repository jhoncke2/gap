import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/bloc/nav_routes/routes_manager.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/bloc/widgets/index/index_bloc.dart';
import 'package:gap/logic/blocs_manager/chosen_form_manager.dart';
import 'package:gap/logic/storage_managers/preloaded_data_uploader.dart';
import 'package:gap/logic/storage_managers/source_data_manager.dart';
import 'package:gap/native_connectors/net_connection_detector.dart';
import 'package:gap/data/fake_data/fake_data.dart' as fakeData;

class PagesNavigationManager{

  static Future<void> pop(BuildContext context)async{
    Navigator.of(context).pop();
    routesManager.pop();
  }
  
  static Future<void> navToProjects(BuildContext context)async{
    await SourceDataManager.updateBlocData(NavigationRoute.Projects);     
    //TODO: evaluación de authToken
    _goToInitialPage(NavigationRoute.Projects, context);
  }

  static Future<bool> _thereIsNetConnection()async{
    return await NetConnectionDetector.netConnectionState == NetConnectionState.Connected;
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
    SourceDataManager.updateBlocData(NavigationRoute.Visits);     
    _goToNextPage(NavigationRoute.Visits, context);
  }

  static Future<void> navToVisitDetail(Visit visit, BuildContext context)async{
    _updateVisitDetail(visit, context);
    
    if(await _thereIsNetConnection())
      _loadForms(context, visit.id);
    _goToNextPage(NavigationRoute.VisitDetail, context);
  }

  static void _updateVisitDetail(Visit visit, BuildContext context){
    final VisitsBloc visitsBloc = BlocProvider.of<VisitsBloc>(context);
    final ChooseVisit svEvent = ChooseVisit(chosenOne: visit);
    visitsBloc.add(svEvent);
  }

  static Future<void> _loadForms(BuildContext context, int visitId)async{
    //TODO: Implementar get from services
    final List<Formulario> formsByVisit = await _obtainFormsFromServices(visitId);
    _setFormsToBloc(context, formsByVisit);
    PreloadedDataUploader.setPreloadedVisitData(formsByVisit, context);
  }

  static void _setFormsToBloc(BuildContext context, List<Formulario> formsByVisit){
    final FormulariosBloc formsBloc = BlocProvider.of<FormulariosBloc>(context);
    final SetForms setFormsEvent = SetForms(forms: formsByVisit);
    formsBloc.add(setFormsEvent);
  }

  static Future<List<Formulario>> _obtainFormsFromServices(int visitId)async{
    final List<Formulario> forms = fakeData.formularios;
    return forms;
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

  static Future<void> endFormFirmers(BuildContext context)async{    
    await _addFirmToFirmer();
    //TODO: El service de enviar formulario Firmers (si hay internet)
    ChosenFormManagerSingleton.chosenFormManager.finishFirms();
    _goToNextPage(NavigationRoute.Formularios, context);
    Navigator.of(context).pushReplacementNamed(NavigationRoute.Formularios.value);
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

}