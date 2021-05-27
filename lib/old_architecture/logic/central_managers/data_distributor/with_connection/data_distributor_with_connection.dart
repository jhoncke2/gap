import 'package:flutter/cupertino.dart';
import 'package:gap/old_architecture/data/enums/enums.dart';
import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/bloc/entities/user/user_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/old_architecture/logic/bloc/nav_routes/custom_navigator.dart';
import 'package:gap/old_architecture/logic/bloc/widgets/commented_images/commented_images_bloc.dart';
import 'package:gap/old_architecture/logic/central_managers/data_distributor/data_distributor.dart';
import 'package:gap/old_architecture/logic/services_manager/projects_services_manager.dart';
import 'package:gap/old_architecture/logic/services_manager/user_services_manager.dart';
import 'package:gap/old_architecture/logic/storage_managers/forms/formularios_storage_manager.dart';
import 'package:gap/old_architecture/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/old_architecture/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/old_architecture/services/auth_service.dart';

class DataDistributorWithConnection extends DataDistributor{
  
  final _AuthTokenValidator _authTokenValidator = _AuthTokenValidator();
  final ProjectsServicesManager _projectsServicesManager = ProjectsServicesManager();

  @override
  Future doInitialConfig()async{
    await super.doInitialConfig();
  }

  @override
  Future updateAccessToken(String accessToken)async{
    _authTokenValidator.userBloc = DataDistributor.blocsAsMap[BlocName.User];
    await _authTokenValidator.refreshAuthToken(accessToken);
  }

  @override
  Future login(Map<String, dynamic> loginInfo)async{
    await super.login(loginInfo);
  }

  Future _doFirstLogin(String email, String password)async{
    userB.add(ChangeLoginButtopnAvaibleless(isAvaible: false));
    await UserServicesManager.login(email, password, CustomNavigatorOld.navigatorKey.currentContext);
    await UserStorageManager.setUserInformation(email, password);
  }

  Future _doReloadingLogin()async{
    final Map<String, dynamic> userInformation = await UserStorageManager.getUserInformation();
    await UserServicesManager.login(userInformation['email'], userInformation['password'], CustomNavigatorOld.navigatorKey.currentContext);
  }

  @override
  Future<void> updateProjects()async{
    await super.updateProjects();
  }

  @override
  Future<void> updateVisits()async{
    await super.updateVisits();
  }

  @override
  Future<void> updateChosenVisit(VisitOld visit)async{
    await super.updateChosenVisit(visit);
  }

  @override
  Future updateChosenForm(FormularioOld form)async{
    await super.updateChosenForm(form);
  }

  @override
  Future<void> updateFormularios()async{
    await super.updateFormularios();
  }

  Future endFormFillingOut()async{
    await super.endFormFillingOut();
  }

  Future _sendFormToService(FormularioOld form)async{
    final VisitOld chosenVisit = visitsB.state.chosenVisit;
    final String accessToken = await UserStorageManager.getAccessToken();
    await ProjectsServicesManager.updateForm(form, chosenVisit.id, accessToken);
    form.campos = [];
    deleteNullFirmersFromForm(form);
    await PreloadedFormsStorageManager.setPreloadedForm(form, chosenVisit.id);
  }

  Future _sendFormFinalPosition(FormularioOld form)async{
    final String accessToken = await UserStorageManager.getAccessToken();
    await ProjectsServicesManager.updateFormFillingOutFinalization(accessToken, form.finalPosition, form.id);
  }

  @override
  Future updateFirmers()async{
    await super.updateFirmers();
  }


  @override
  Future endAllFormProcess()async{
    await super.endAllFormProcess();
  }

  @override
  Future updateCommentedImages()async{
    await super.updateCommentedImages();
  }

  @override
  Future resetForms()async{
    await super.resetForms();
  }


  Future endCommentedImagesProcess()async{
    await super.endCommentedImagesProcess();
  }

  Future _postUnsetCommentedImages()async{
    final String accessToken = await UserStorageManager.getAccessToken();
    final List<CommentedImageOld> commImgs = commImgsB.state.allCommentedImages.toList();
    final VisitOld chosenVisit = visitsB.state.chosenVisit;
    commImgsB.add(ResetCommentedImages());
    if(commImgs.length > 0)
      await ProjectsServicesManager.saveCommentedImages(accessToken, commImgs.cast<UnSentCommentedImageOld>(), chosenVisit.id);
  }
}

class _AuthTokenValidator{
  UserOldBloc userBloc;
  Future refreshAuthToken(String oldAuthToken)async{
    final Map<String, dynamic> authTokenResponse = await authService.refreshAuthToken(oldAuthToken);
    String newAuthToken = authTokenResponse['data']['original']['access_token'];
    await UserStorageManager.setAccessToken(newAuthToken);
    userBloc.add(SetAccessToken(accessToken: newAuthToken));
  }
}