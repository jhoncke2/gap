import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/central_managers/data_distributor/data_distributor.dart';
import 'package:gap/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/preloaded_visits_storage_manager.dart';

class SourceDataToBlocWithoutConnection extends DataDistributor{
  
  @override
  Future doInitialConfig()async{
    final String accessToken = await UserStorageManager.getAccessToken();
    _updateAccessToken(accessToken);
  }

  void _updateAccessToken(String accessToken){
    final UserBloc uBloc = DataDistributor.blocsAsMap[BlocName.User];
    uBloc.add(SetAccessToken(accessToken: accessToken));
  }

  @override
  Future<void> updateProjects()async{
    //final ProjectsBloc projectsB = blocsAsMap[BlocName.Projects];
    final List<Project> projectsWithPreloadedVisits = await ProjectsStorageManager.getProjectsWithPreloadedVisits();
    final SetProjects spEvent = SetProjects(projects: projectsWithPreloadedVisits);
    projectsB.add(spEvent);
    await ProjectsStorageManager.setProjects(projectsWithPreloadedVisits);
    UploadedBlocsData.dataContainer[NavigationRoute.Projects] = projectsWithPreloadedVisits;
  }

  @override
  Future<void> updateVisits()async{
    final Project chosenProject = UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail];
    List<Visit> preloadedVisits = await PreloadedVisitsStorageManager.getVisitsByProjectId(chosenProject.id);
    preloadedVisits = preloadedVisits.where((element) => !element.completo).toList();
    final SetVisits svEvent = SetVisits(visits: preloadedVisits);
    visitsB.add(svEvent);
    UploadedBlocsData.dataContainer[NavigationRoute.Visits] = preloadedVisits;
  }

  @override
  Future updateChosenVisit(Visit visit)async{
    final Visit realVisit = getUpdatedChosenVisit(visit);
    await super.updateChosenVisit(realVisit);
    await _updateFormularios(realVisit);
    UploadedBlocsData.dataContainer[NavigationRoute.Visits] = realVisit;
  }

  Future _updateFormularios(Visit chosenVisit)async{
    final List<Formulario> formsGroupedByPreloadedVisit = await PreloadedFormsStorageManager.getPreloadedFormsByVisitId(chosenVisit.id);
    final SetForms sfEvent = SetForms(forms: formsGroupedByPreloadedVisit);
    formsB.add(sfEvent);
  }

  @override
  Future<void> updateFormularios()async{
    //final FormulariosBloc formsB = blocsAsMap[BlocName.Formularios];
    await super.updateFormularios();
    //final Visit chosenVisit = UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail];
    //final List<Formulario> formsGroupedByPreloadedVisit = await PreloadedFormsStorageManager.getPreloadedFormsByVisitId(chosenVisit.id);
    //final SetForms sfEvent = SetForms(forms: formsGroupedByPreloadedVisit);
    //formsB.add(sfEvent);
    //UploadedBlocsData.dataContainer[NavigationRoute.Formularios] = formsGroupedByPreloadedVisit;
  }

  @override
  Future updateChosenForm(Formulario form)async{
    Formulario realForm = await getUpdatedChosenForm(form);
    await addInitialPosition(realForm);
    super.updateChosenForm(realForm);
  }

  @override
  Future endAllFormProcess()async{
    await super.endAllFormProcess();
    final Formulario chosenForm = formsB.state.chosenForm;
    final Visit chosenVisit = visitsB.state.chosenVisit;
    await PreloadedFormsStorageManager.setPreloadedForm(chosenForm, chosenVisit.id);
  }

  @override
  Future resetChosenVisit()async{
    final List<Formulario> forms = formsB.state.forms;
    final bool chosenVisitIsCompleted = _chosenVisitIsCompleted(forms);
    if(chosenVisitIsCompleted){
      await _changeDataOfVisitRecentlyCompleted();
    }
    await super.resetChosenVisit();
  }

  bool _chosenVisitIsCompleted(List<Formulario> forms){
    for(Formulario form in forms){
      if(!form.completo)
        return false;
    }
    return true;
  }

  Future _changeDataOfVisitRecentlyCompleted()async{
    visitsB.state.chosenVisit.completo = true;
    final int chosenProjectId = projectsB.state.chosenProject.id;
    await PreloadedVisitsStorageManager.setVisit(visitsB.state.chosenVisit, chosenProjectId);
    await _replaceAllVisitsInBloc(visitsB.state.chosenVisit);
  }

  Future _replaceAllVisitsInBloc(Visit chosenVisit)async{
    List<Visit> visits = visitsB.state.visits;
    final int indexOfChosenVisit = visits.indexWhere((element) => element.id == chosenVisit.id);
    if(indexOfChosenVisit == -1)
      visits.add(chosenVisit);
    else
      visits[indexOfChosenVisit] = chosenVisit;
    visits = visits.where((element) => !element.completo).toList();
    visitsB.add(SetVisits(visits: visits));
  }
}