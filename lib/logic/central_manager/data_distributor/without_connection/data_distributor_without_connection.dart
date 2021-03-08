import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/central_manager/data_distributor/data_distributor.dart';
import 'package:gap/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/preloaded_visits_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';

class SourceDataToBlocWithoutConnection extends DataDistributor{
  
  @override
  Future<void> updateAccessToken()async{
    final String accessToken = await UserStorageManager.getAccessToken();
    final UserBloc uBloc = DataDistributor.blocsAsMap[BlocName.User];
    uBloc.add(SetAccessToken(accessToken: accessToken));
  }

  @override
  Future<void> updateProjects()async{
    //final ProjectsBloc projectsB = blocsAsMap[BlocName.Projects];
    final List<Project> projectsWithPreloadedVisits = await ProjectsStorageManager.getProjectsWithPreloadedVisits();
    final SetProjects spEvent = SetProjects(projects: projectsWithPreloadedVisits);
    projectsB.add(spEvent);
    ProjectsStorageManager.setProjects(projectsWithPreloadedVisits);
  }

  @override
  Future<void> updateVisits()async{
    //final VisitsBloc visitsB = blocsAsMap[BlocName.Visits];
    final Project chosenProject = UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail];
    final List<Visit> preloadedVisits = await PreloadedVisitsStorageManager.getVisitsByProjectId(chosenProject.id);
    final SetVisits svEvent = SetVisits(visits: preloadedVisits);
    visitsB.add(svEvent);
  }

  @override
  Future updateChosenVisit(Visit visit)async{
    await super.updateChosenVisit(visit);
    await _updateFormularios(visit);
    
    //await addChosenVisitToBloc(visit);
    //await _addVisitToStorage(visit);
  }

  Future _updateFormularios(Visit chosenVisit)async{
    //final FormulariosBloc formsB = blocsAsMap[BlocName.Formularios];
    final List<Formulario> formsGroupedByPreloadedVisit = await PreloadedFormsStorageManager.getPreloadedFormsByVisitId(chosenVisit.id);
    final SetForms sfEvent = SetForms(forms: formsGroupedByPreloadedVisit);
    formsB.add(sfEvent);
  }

  Future _addVisitToStorage(Visit visit)async{
    await VisitsStorageManager.setChosenVisit(visit);
  }

  @override
  Future<void> updateFormularios()async{
    //final FormulariosBloc formsB = blocsAsMap[BlocName.Formularios];
    final Visit chosenVisit = UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail];
    final List<Formulario> formsGroupedByPreloadedVisit = await PreloadedFormsStorageManager.getPreloadedFormsByVisitId(chosenVisit.id);
    final SetForms sfEvent = SetForms(forms: formsGroupedByPreloadedVisit);
    formsB.add(sfEvent);
  }
}