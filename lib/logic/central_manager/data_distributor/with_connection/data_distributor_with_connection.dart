import 'package:flutter/cupertino.dart';
import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/errors/storage/unfound_storage_element_err.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/bloc/nav_routes/custom_navigator.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/logic/central_manager/data_distributor/data_distributor.dart';
import 'package:gap/logic/central_manager/preloaded_storage_to_services.dart';
import 'package:gap/logic/services_manager/projects_services_manager.dart';
import 'package:gap/logic/services_manager/user_services_manager.dart';
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
    if(accessToken == null)
      throw UnfoundStorageElementErr(elementType: StorageElementType.AUTH_TOKEN);
    await updateAccessToken(accessToken);
    await PreloadedStorageToServices.sendPreloadedStorageDataToServices();
  }

  @override
  Future updateAccessToken(String accessToken)async{
    _authTokenValidator.userBloc = DataDistributor.blocsAsMap[BlocName.User];
    await _authTokenValidator.refreshAuthToken(accessToken);
  }

  @override
  Future login(Map<String, dynamic> loginInfo)async{
    if(loginInfo['type'] == 'first_login')
      await _doFirstLogin(loginInfo['email'], loginInfo['password']);
    else
      await _doPreloadingLogin(); 
  }

  Future _doFirstLogin(String email, String password)async{
    await UserServicesManager.login(email, password, CustomNavigator.navigatorKey.currentContext);
    await UserStorageManager.setUserInformation(email, password);
  }

  Future _doPreloadingLogin()async{
    final Map<String, dynamic> userInformation = await UserStorageManager.getUserInformation();
    await UserServicesManager.login(userInformation['email'], userInformation['password'], CustomNavigator.navigatorKey.currentContext);
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
    if(!form.completo){
      deleteNullFirmersFromForm(form);
      await PreloadedFormsStorageManager.setPreloadedForm(form, visitId);
    }
      
  }

  @override
  Future updateChosenForm(Formulario form)async{
    Formulario realForm = await getUpdatedChosenForm(form);
    if(realForm.initialPosition == null)
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
    deleteNullFirmersFromForm(form);
    await PreloadedFormsStorageManager.setPreloadedForm(form, chosenVisit.id);
  }

  Future _sendFormFinalPosition(Formulario form)async{
    final String accessToken = await UserStorageManager.getAccessToken();
    await ProjectsServicesManager.updateFormFillingOutFinalization(accessToken, form.finalPosition, form.id);
  }

  @override
  Future updateFirmers()async{
    await super.updateFirmers();
    await sendFirmerToService();
  }

  @protected
  Future sendFirmerToService()async{
    final Formulario chosenForm = formsB.state.chosenForm;
    final PersonalInformation lastFirmer = chosenForm.firmers.last.clone();
    final String accessToken = await UserStorageManager.getAccessToken();
    final Visit chosenVisit = visitsB.state.chosenVisit;
    await ProjectsServicesManager.saveFirmer(accessToken, lastFirmer, chosenForm.id, chosenVisit.id);
    chosenForm.firmers.removeAt(0);
    await updateChosenFormInStorage(chosenForm);
    //await PreloadedFormsStorageManager.setPreloadedForm(chosenForm, chosenVisit.id);
    //await ChosenFormStorageManager.setChosenForm(chosenForm);
  }

  @override
  Future endAllFormProcess()async{
    await super.endAllFormProcess();
    await sendFirmerToService();
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
  Future updateCommentedImages()async{
    visitsB.add(ChangeChosenVisitBlocking(isBlocked: true));
    final String accessToken = await UserStorageManager.getAccessToken();
    final Visit chosenVisit = UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail];
    final List<CommentedImage> cmmImages = await ProjectsServicesManager.getCommentedImages(accessToken, chosenVisit.id);
    if(cmmImages.isEmpty){
      commImgsB.add(InitImagesCommenting());
    }else{
      commImgsB.add(InitSentCommImgsWatching(sentCommentedImages: cmmImages, onEnd: changeNPagesToIndex));
    }
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
    visitsB.add(ChangeChosenVisitBlocking(isBlocked: false));
    if(commImgsB.state.dataType == CmmImgDataType.UNSENT)
      await _postUnsetCommentedImages();
    else
      commImgsB.add(ResetCommentedImages());
    await super.endCommentedImagesProcess();
  }

  Future _postUnsetCommentedImages()async{
    final String accessToken = await UserStorageManager.getAccessToken();
    final List<CommentedImage> commImgs = commImgsB.state.allCommentedImages.toList();
    final Visit chosenVisit = visitsB.state.chosenVisit;
    commImgsB.add(ResetCommentedImages());
    if(commImgs.length > 0)
      await ProjectsServicesManager.saveCommentedImages(accessToken, commImgs.cast<UnSentCommentedImage>(), chosenVisit.id);
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