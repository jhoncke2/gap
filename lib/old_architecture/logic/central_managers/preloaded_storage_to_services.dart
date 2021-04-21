import 'package:gap/old_architecture/data/models/entities/entities.dart';
import 'package:gap/old_architecture/logic/services_manager/projects_services_manager.dart';
import 'package:gap/old_architecture/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/old_architecture/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/old_architecture/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/old_architecture/logic/storage_managers/visits/preloaded_visits_storage_manager.dart';
import 'package:gap/old_architecture/ui/utils/dialogs.dart' as dialogs;

bool anyDataWasSended;

class PreloadedStorageToServices{
  static final _ProjectEvaluater _projectEvaluater = _ProjectEvaluater();
  
  static Future<void> sendPreloadedStorageDataToServices()async{
    anyDataWasSended = false;
    final List<ProjectOld> preloadedProjects = await ProjectsStorageManager.getProjectsWithPreloadedVisits();
    final String accessToken = await UserStorageManager.getAccessToken();
    for(ProjectOld p in preloadedProjects){
      await _projectEvaluater.evaluatePreloadedProject(p.id, accessToken);
    }
    await _showEndDialogIfAnyDataWasSended();
    _resetProjectEvaluater();
  }

  static void _resetProjectEvaluater(){
    _projectEvaluater.projectIsFinished = true;
  }

  static Future _showEndDialogIfAnyDataWasSended()async{
    if(anyDataWasSended)
      await dialogs.showTemporalDialog('Se ha enviado la data precargada');
  }
}

class _ProjectEvaluater{
  _VisitEvaluater _visitEvaluater;
  bool projectIsFinished = true;

  Future<void> evaluatePreloadedProject(int projectId, String accessToken)async{
    _visitEvaluater = _VisitEvaluater();
    final List<VisitOld> preloadedVisits = await PreloadedVisitsStorageManager.getVisitsByProjectId(projectId);
    for(VisitOld v in preloadedVisits){
      await _evaluateVisit(v, projectId, accessToken);
    }
    await _endPreloadedProjectIfFinished(projectId);
    _resetVisitEvaluater();
  }

  Future<void> _evaluateVisit(VisitOld visit, int projectId, String accessToken)async{
    await _visitEvaluater.evaluatePreloadedVisit(visit, projectId, accessToken);
    projectIsFinished = _visitEvaluater.visitIsFinished? projectIsFinished : false;
  }

  Future<void> _endPreloadedProjectIfFinished(int projectId)async{
    if(projectIsFinished){
      await _endPreloadedProject(projectId);
    }
  }

  Future<void> _endPreloadedProject(int projectId)async{
    await ProjectsStorageManager.removeProjectWithPreloadedVisits(projectId);
  }

  void _resetVisitEvaluater(){
    _visitEvaluater.visitIsFinished = true;
  }
}


class _VisitEvaluater{
  final _FormEvaluater _formEvaluater = _FormEvaluater();
  bool visitIsFinished = true;

  Future<void> evaluatePreloadedVisit(VisitOld visit, int projectId, String accessToken)async{
    
    final List<FormularioOld> preloadedForms = await PreloadedFormsStorageManager.getPreloadedFormsByVisitId(visit.id);
    for(FormularioOld f in preloadedForms){
      await _evaluateForm(f, visit.id, accessToken);
    }
    await _removePreloadedVisitIfFinished(visit, projectId);

  }

  Future<void> _evaluateForm(FormularioOld f, int visitId, String accessToken)async{
    await _formEvaluater.evaluatePreloadedForm(f, visitId, accessToken);
    visitIsFinished = _formEvaluater.formIsFinished? visitIsFinished : false;
  }

  Future<void> _removePreloadedVisitIfFinished(VisitOld visit, int projectId)async{
    if(visitIsFinished || visit.completo){
      await _removePreloadedVisit(visit.id, projectId);
    }
  }

  Future<void> _removePreloadedVisit(int visitId, int projectId)async{
    PreloadedVisitsStorageManager.removeVisit(visitId, projectId);
  }
}

class _FormEvaluater{
  String _accessToken;
  bool formIsFinished;

  Future<void> evaluatePreloadedForm(FormularioOld form, int visitId, String accessToken)async{
    _accessToken = accessToken;
    if(form.completo){
      await _evaluateFinishedPreloadedForm(form, visitId);
    }else{
      formIsFinished = false;
    }
  }

  Future<void> _evaluateFinishedPreloadedForm(FormularioOld form, int visitId)async{
    try{
      await _endPreloadedForm(form, visitId);
      formIsFinished = true;
    }catch(err){
      formIsFinished = false;
    }
  }

  Future<void> _endPreloadedForm(FormularioOld form, int visitId)async{
    await _sendFormIfHasFields(form, visitId);
    await _sendFirmersIfHasFirmers(form, visitId);
    //await PreloadedFormsStorageManager.removePreloadedForm(form.id, visitId);
    await _removePreloadedFormIfFinished(form, visitId);
    //Test
    final List<FormularioOld> preloadedForms = await PreloadedFormsStorageManager.getPreloadedFormsByVisitId(visitId);
    print(preloadedForms);
  }

  Future _sendFormIfHasFields(FormularioOld form, int visitId)async{
    if(form.initialPosition != null){
      await ProjectsServicesManager.updateFormInitialization(_accessToken, form.initialPosition, form.id);
      form.initialPosition = null;
    }   
    if(_formHasFields(form)){
      await ProjectsServicesManager.updateForm(form, visitId, _accessToken);
      anyDataWasSended = true;  
      form.campos = [];
      await PreloadedFormsStorageManager.setPreloadedForm(form, visitId);
    }
    if(form.finalPosition != null){
      await ProjectsServicesManager.updateFormFillingOutFinalization(_accessToken, form.finalPosition, form.id);
      form.finalPosition = null;
    }
      
  }

  Future _sendFirmersIfHasFirmers(FormularioOld form, int visitId)async{
    if(_formHasFirmers(form))
      await _sendFirmers(form, visitId);
  }

  bool _formHasFields(FormularioOld form){
    return form.campos!=null && form.campos.length > 0;
  }

  bool _formHasFirmers(FormularioOld form){
    return form.firmers.length > 0;
  }

  Future _sendFirmers(FormularioOld form, int visitId)async{
    for(PersonalInformationOld firmer in form.firmers){
      await ProjectsServicesManager.saveFirmer(_accessToken, firmer, form.id, visitId);
      anyDataWasSended = true;
    }
  }

  Future _removePreloadedFormIfFinished(FormularioOld form, int visitId)async{
    if(form.campos == [] && form.initialPosition == null && form.finalPosition == null)
      await PreloadedFormsStorageManager.removePreloadedForm(form.id, visitId);
  }
}