import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/central_manager/data_distributor/data_distributor.dart';
import 'package:gap/logic/services_manager/projects_services_manager.dart';
import 'package:gap/logic/storage_managers/forms/chosen_form_storage_manager.dart';
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
    _authTokenValidator.userBloc = DataDistributor.blocsAsMap[BlocName.User];
    await _authTokenValidator.refreshAuthToken();
  }

  @override
  Future<void> updateProjects()async{
    final String accessToken = await UserStorageManager.getAccessToken();
    final List<Project> projects = await ProjectsServicesManager.loadProjects(projectsB, accessToken);
    projectsB.add(SetProjects(projects: projects));
  }

  @override
  Future<void> updateChosenProject(Project project)async{
    super.updateChosenProject(project);
    ProjectsStorageManager.setChosenProject(project);
    UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail] = project;
  }

   @override
  Future<void> updateVisits()async{
    final Project chosenProject = UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail];
    final List<Visit> visits = chosenProject.visits;
    visitsB.add(SetVisits(visits: visits));
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
    final Visit chosenVisit = UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail];
    final List<Formulario> forms = chosenVisit.formularios;
    formsB.add(SetForms(forms: forms));
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

  Future endFormFillingOut()async{
    await super.endFormFillingOut();
    await _sendFormToService();
  }

  Future _sendFormToService()async{
    try{
      await _trySendFormToService();
    }catch(err){
    }
  }

  Future _trySendFormToService()async{
    final Formulario chosenForm = formsB.state.chosenForm;
    final Visit chosenVisit = visitsB.state.chosenVisit;
    final String accessToken = await UserStorageManager.getAccessToken();
    await ProjectsServicesManager.updateForm(chosenForm, chosenVisit.id, accessToken);
    chosenForm.campos = [];
    await PreloadedFormsStorageManager.setPreloadedForm(chosenForm, chosenVisit.id);
  }

  bool updateFormsVisitIsOk(){
    
  }

  @override
  Future updateFirmers()async{
    await super.updateFirmers();
    await _sendFirmerToService();
  }

  Future _sendFirmerToService()async{
    try{
      await _trySendFirmerToService();
    }catch(err){
    }
  }

  Future _trySendFirmerToService()async{
    final Formulario chosenForm = formsB.state.chosenForm;
    final PersonalInformation lastFirmer = chosenForm.firmers.last;
    final String accessToken = await UserStorageManager.getAccessToken();
    final Visit chosenVisit = visitsB.state.chosenVisit;
    await ProjectsServicesManager.saveFirmer(accessToken, lastFirmer, chosenForm.id, chosenVisit.id);
    chosenForm.firmers.removeLast();
    await PreloadedFormsStorageManager.setPreloadedForm(chosenForm, chosenVisit.id);
    await ChosenFormStorageManager.setChosenForm(chosenForm);
  }

  @override
  Future endAllFormProcess()async{
    await super.endAllFormProcess();
    final String accessToken = await UserStorageManager.getAccessToken();
    final Visit chosenVisit = visitsB.state.chosenVisit;
    final Formulario chosenForm = formsB.state.chosenForm;
    //final List<Map<String, dynamic>> visitResponse = await ProjectsServicesManager.updateForm(chosenForm, chosenVisit.id, accessToken);
    //await _removeFormFromPreloadedStorageIfSuccessResponse(visitResponse, chosenForm.id, chosenVisit.id);
  }

  Future _removeFormFromPreloadedStorageIfSuccessResponse(List<Map<String, dynamic>> updatedFormResponse, int formId, int visitId)async{
    if(_updatedFormResponseIsSuccessful(updatedFormResponse))
      await PreloadedFormsStorageManager.removePreloadedForm(formId, visitId);
  }

  bool _updatedFormResponseIsSuccessful(List<Map<String, dynamic>> updatedFormResponse){
    return updatedFormResponse !=  null && updatedFormResponse.length > 0;
  }


  @override
  Future resetForms()async{
    final Visit chosenVisit = visitsB.state.chosenVisit;
    await _removeVisitFromPreloadedVisitsIfCompleted(chosenVisit);
    await _removeFormsFromStorage();
  }

  Future _removeVisitFromPreloadedVisitsIfCompleted(Visit visit)async{
    if(visit.stage == ProcessStage.Realizada)
      await _removeVisitFromPReloadedVisits(visit);
  }

  Future _removeVisitFromPReloadedVisits(Visit visit)async{
    final Project chosenProject = projectsB.state.chosenProjectOld;
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
    return await UserStorageManager.getAccessToken();
  }

  Future _refreshAuthToken(String oldAuthToken)async{
    final Map<String, dynamic> authTokenResponse = await authService.refreshAuthToken(oldAuthToken);
    String newAuthToken = authTokenResponse['data']['original']['access_token'];
    await UserStorageManager.setAccessToken(newAuthToken);
    userBloc.add(SetAccessToken(accessToken: newAuthToken));
  }
}