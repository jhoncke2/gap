import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/central_manager/data_distributor/data_distributor.dart';
import 'package:gap/logic/central_manager/preloaded_storage_to_services.dart';
import 'package:gap/logic/services_manager/projects_services_manager.dart';
import 'package:gap/logic/storage_managers/forms/chosen_form_storage_manager.dart';
import 'package:gap/logic/storage_managers/forms/formularios_storage_manager.dart';
import 'package:gap/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/preloaded_visits_storage_manager.dart';
import 'package:gap/services/auth_service.dart';

class DataDistributorWithConnection extends DataDistributor{
  
  final _AuthTokenValidator _authTokenValidator = _AuthTokenValidator();
  final ProjectsServicesManager _projectsServicesManager = ProjectsServicesManager();

  @override
  Future doInitialConfig()async{
    final accessToken = await UserStorageManager.getAccessToken();
    await updateAccessToken(accessToken);
    await PreloadedStorageToServices.sendPreloadedStorageDataToServices();
  }

  @override
  Future updateAccessToken(String accessToken)async{
    _authTokenValidator.userBloc = DataDistributor.blocsAsMap[BlocName.User];
    await _authTokenValidator.refreshAuthToken(accessToken);
  }

  @override
  Future<void> updateProjects()async{
    final String accessToken = await UserStorageManager.getAccessToken();
    final List<Project> projects = await _projectsServicesManager.loadProjects(projectsB, accessToken);
    projectsB.add(SetProjects(projects: projects));  
    UploadedBlocsData.dataContainer[NavigationRoute.Projects] = projects;
  }

  @override
  Future<void> updateVisits()async{
    final Project chosenProject = UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail];
    final List<Visit> visits = chosenProject.visits;
    visitsB.add(SetVisits(visits: visits));
    UploadedBlocsData.dataContainer[NavigationRoute.Visits] = visits;
  }

  @override
  Future<void> updateChosenVisit(Visit visit)async{
    final Visit realVisit = getUpdatedChosenVisit(visit);
    await super.updateChosenVisit(realVisit);
    await _addPreloadedDataRelatedToChosenProjectIfVisitIsntCompleted(realVisit);
    await _loadFormsByChosenVisit(realVisit);
  }

  Future _addPreloadedDataRelatedToChosenProjectIfVisitIsntCompleted(Visit visit)async{
    if(!visit.completo)
      await _addPreloadedDataRelatedToChosenProject(visit);
  }

  Future _addPreloadedDataRelatedToChosenProject(Visit visit)async{
    final Project chosenProject = UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail];
    await ProjectsStorageManager.setProjectWithPreloadedVisits(chosenProject);
    await PreloadedVisitsStorageManager.setVisit(visit, chosenProject.id);
  }

  Future _loadFormsByChosenVisit(Visit visit)async{
    final Visit chosenVisit = UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail];
    final List<Formulario> forms = chosenVisit.formularios;
    formsB.add(SetForms(forms: forms));
    await _addFormsToPreloadedStorageIfVisitIsntCompleted(forms, visit);
  }

  Future _addFormsToPreloadedStorageIfVisitIsntCompleted(List<Formulario> forms, Visit visit)async{
    if(!visit.completo)
      await _addFormsToPreloadedStorage(forms, visit.id);
  }

  Future _addFormsToPreloadedStorage(List<Formulario> forms, int visitId)async{
    for(Formulario form in forms)
        await _addFormToPreloadedStorageIfIsntCompleted(form, visitId);
  }

  Future _addFormToPreloadedStorageIfIsntCompleted(Formulario form, int visitId)async{
    if(!form.completo)
      await PreloadedFormsStorageManager.setPreloadedForm(form, visitId);
  }

  @override
  Future updateChosenForm(Formulario form)async{
    Formulario realForm = await getUpdatedChosenForm(form);
    await addInitialPosition(realForm);
    final String accessToken = await UserStorageManager.getAccessToken();
    await ProjectsServicesManager.updateFormInitialization(accessToken, realForm.initialPosition, realForm.id);
    await super.updateChosenForm(realForm);
  }

  @override
  Future<void> updateFormularios()async{
  }

  Future endFormFillingOut()async{
    await super.endFormFillingOut();
    final Formulario chosenForm = formsB.state.chosenForm;
    await _sendFormToService(chosenForm);
    await _sendFormFinalPosition(chosenForm);
  }

  Future _sendFormToService(Formulario form)async{
    final Visit chosenVisit = visitsB.state.chosenVisit;
    final String accessToken = await UserStorageManager.getAccessToken();
    await ProjectsServicesManager.updateForm(form, chosenVisit.id, accessToken);
    form.campos = [];
    await PreloadedFormsStorageManager.setPreloadedForm(form, chosenVisit.id);
  }

  Future _sendFormFinalPosition(Formulario form)async{
    final String accessToken = await UserStorageManager.getAccessToken();
    await ProjectsServicesManager.updateFormFillingOutFinalization(accessToken, form.finalPosition, form.id);
  }

  @override
  Future updateFirmers()async{
    await super.updateFirmers();
    await _sendFirmerToService();
  }

  Future _sendFirmerToService()async{
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
    await _updatePreloadedDataAfterFormProcessEnd();
  }

  Future _updatePreloadedDataAfterFormProcessEnd()async{
    final Visit chosenVisit = visitsB.state.chosenVisit;
    final Formulario chosenForm = formsB.state.chosenForm;
    await _removeChosenFormFromPreloadedStorage(chosenVisit.id, chosenForm.id);
    final Project chosenProject = projectsB.state.chosenProject;
    await _removePreloadedVisitIfThereIsNoMoreForms(chosenVisit.id, chosenProject.id);
    await _removePreloadedProjectIfThereIsNoMoreVisits(chosenProject.id);
  }

  Future _removeChosenFormFromPreloadedStorage(int chosenVisitId, int chosenFormId)async{
    await PreloadedFormsStorageManager.removePreloadedForm(chosenVisitId, chosenFormId);
  }

  Future _removePreloadedVisitIfThereIsNoMoreForms(int chosenVisitId, int chosenProjectId)async{
    final List<Formulario> preloadedForms = await PreloadedFormsStorageManager.getPreloadedFormsByVisitId(chosenVisitId);
    if(preloadedForms.length == 0)
      await PreloadedVisitsStorageManager.removeVisit(chosenVisitId, chosenProjectId);
  }

  Future _removePreloadedProjectIfThereIsNoMoreVisits(int chosenProjectId)async{
    final List<Visit> preloadedVisits = await PreloadedVisitsStorageManager.getVisitsByProjectId(chosenProjectId);
    if(preloadedVisits.length == 0)
      await ProjectsStorageManager.removeProjectWithPreloadedVisits(chosenProjectId);
  }

  @override
  Future resetForms()async{
    await super.resetForms();
    final Visit chosenVisit = visitsB.state.chosenVisit;
    await _removeVisitFromPreloadedVisitsIfCompleted(chosenVisit);
    await _removeFormsFromStorage();
  }

  Future _removeVisitFromPreloadedVisitsIfCompleted(Visit visit)async{
    if(visit.stage == ProcessStage.Realizada)
      await _removeVisitFromPReloadedVisits(visit);
  }

  Future _removeVisitFromPReloadedVisits(Visit visit)async{
    final Project chosenProject = projectsB.state.chosenProject;
    await PreloadedVisitsStorageManager.removeVisit(visit.id, chosenProject.id);
  }

  Future _removeFormsFromStorage()async{
    await FormulariosStorageManager.removeForms();
  }

  Future endCommentedImagesProcess()async{
    try{
      await _tryEndCommentedImagesProcess();
    }catch(err){
    }
  }

  Future _tryEndCommentedImagesProcess()async{
    final String accessToken = await UserStorageManager.getAccessToken();
    final CommentedImagesBloc commImgsB = DataDistributor.blocsAsMap[BlocName.CommentedImages];
    final List<CommentedImage> commImgs = commImgsB.state.allCommentedImages;
    final Visit chosenVisit = visitsB.state.chosenVisit;
    await ProjectsServicesManager.saveCommentedImages(accessToken, commImgs, chosenVisit.id);
    await super.endCommentedImagesProcess();
  }
}

class _AuthTokenValidator{
  UserBloc userBloc;
  Future refreshAuthToken(String oldAuthToken)async{
    final Map<String, dynamic> authTokenResponse = await authService.refreshAuthToken(oldAuthToken);
    String newAuthToken = authTokenResponse['data']['original']['access_token'];
    await UserStorageManager.setAccessToken(newAuthToken);
    userBloc.add(SetAccessToken(accessToken: newAuthToken));
  }
}