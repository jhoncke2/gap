import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/central_manager/data_distributor/data_distributor.dart';
import 'package:gap/logic/services_manager/projects_services_manager.dart';
import 'package:gap/logic/storage_managers/forms/formularios_storage_manager.dart';
import 'package:gap/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/preloaded_visits_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';
import 'package:gap/services/auth_service.dart';

class DataDistributorWithConnection extends DataDistributor{
  
  final _AuthTokenValidator _authTokenValidator = _AuthTokenValidator();

  @override
  Future updateAccessToken()async{
    _authTokenValidator.userBloc = blocsAsMap[BlocName.User];
    await _authTokenValidator.refreshAuthToken();
  }

  @override
  Future<void> updateProjects()async{
    final ProjectsBloc pBloc = blocsAsMap[BlocName.Projects];
    //final UserBloc userBloc = blocsAsMap[BlocName.UserBloc];
    //final String accessToken = userBloc.state.authToken;
    final String accessToken = await UserStorageManager.getAuthToken();
    final List<Project> projects = await ProjectsServicesManager.loadProjects(pBloc, accessToken);
    pBloc.add(SetProjects(projects: projects));
  }

  @override
  Future<void> updateChosenProject(Project project)async{
    super.updateChosenProject(project);
    ProjectsStorageManager.setChosenProject(project);
    UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail] = project;
  }

   @override
  Future<void> updateVisits()async{
    final VisitsBloc vBloc = blocsAsMap[BlocName.Visits];
    final Project chosenProject = UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail];
    final List<Visit> visits = chosenProject.visits;
    vBloc.add(SetVisits(visits: visits));
    //await VisitsServicesManager.loadVisits(vBloc);
  }

  @override
  Future<void> updateChosenVisit(Visit visit)async{
    await super.addChosenVisitToBloc(visit);
    _addPreloadedDataRelatedToChosenProject(visit);
    await _loadFormsByChosenVisit(visit.id);
    await _addVisitToStorage(visit);
  }

  Future _addPreloadedDataRelatedToChosenProject(Visit visit)async{
    final Project chosenProject = UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail];
    await ProjectsStorageManager.setProjectWithPreloadedVisits(chosenProject);
    await PreloadedVisitsStorageManager.setVisit(visit, chosenProject.id);
  }

  Future _loadFormsByChosenVisit(int visitId)async{
    final FormulariosBloc fBloc = blocsAsMap[BlocName.Formularios];
    //final List<Formulario> forms = await FormsServicesManager.loadForms(fBloc, visitId);
    final Visit chosenVisit = UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail];
    final List<Formulario> forms = chosenVisit.formularios;
    fBloc.add(SetForms(forms: forms));
    for(Formulario form in forms)
      await _addFormToPreloadedStorage(form, visitId);
  }

  Future _addFormToPreloadedStorage(Formulario form, int visitId)async{
    await PreloadedFormsStorageManager.setPreloadedForm(form, visitId);
  }

  Future _addVisitToStorage(Visit visit)async{
    await VisitsStorageManager.setChosenVisit(visit);
  }

  @override
  Future<void> updateFormularios()async{
  }

  @override
  Future resetForms()async{
    final VisitsBloc vBloc = blocsAsMap[BlocName.Visits];
    final Visit chosenVisit = vBloc.state.chosenVisit;
    await _removeVisitFromPreloadedVisitsIfCompleted(chosenVisit);
    await _removeFormsFromStorage();
  }

  Future _removeVisitFromPreloadedVisitsIfCompleted(Visit visit)async{
    if(visit.stage == ProcessStage.Realizada)
      await _removeVisitFromPReloadedVisits(visit);
  }

  Future _removeVisitFromPReloadedVisits(Visit visit)async{
    final ProjectsBloc pBloc = blocsAsMap[BlocName.Projects];
    final Project chosenProject = pBloc.state.chosenProjectOld;
    await PreloadedVisitsStorageManager.removeVisit(visit.id, chosenProject.id);
  }

  Future _removeFormsFromStorage()async{
    await FormulariosStorageManager.removeForms();
  }
}

class _AuthTokenValidator{

  UserBloc userBloc;

  Future refreshAuthToken()async{
    final String authToken = await _obtainAuthTokenFromStorage();
    await _refreshAuthToken(authToken);
  }
 
  Future _obtainAuthTokenFromStorage()async{
    return await UserStorageManager.getAuthToken();
  }

  Future _refreshAuthToken(String authToken)async{
    final Map<String, dynamic> authTokenResponse = await authService.refreshAuthToken(authToken);
    authToken = authTokenResponse['data']['original']['access_token'];
    await UserStorageManager.setAuthToken(authToken);
    userBloc.add(SetAccessToken(accessToken: authToken));
  }
}