import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/services_manager/projects_services_manager.dart';
import 'package:gap/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/user/user_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/preloaded_visits_storage_manager.dart';

class PreloadedStorageToServices{
  static final _ProjectEvaluater _projectEvaluater = _ProjectEvaluater();
  
  static Future<void> sendPreloadedStorageDataToServices()async{
    final List<Project> preloadedProjects = await ProjectsStorageManager.getProjectsWithPreloadedVisits();
    final String accessToken = await UserStorageManager.getAccessToken();
    for(Project p in preloadedProjects){
      await _projectEvaluater.evaluatePreloadedProject(p.id, accessToken);
    }
    _resetProjectEvaluater();
  }

  static void _resetProjectEvaluater(){
    _projectEvaluater.projectIsFinished = true;
  }
}

class _ProjectEvaluater{
  _VisitEvaluater _visitEvaluater;
  bool projectIsFinished = true;

  Future<void> evaluatePreloadedProject(int projectId, String accessToken)async{
    _visitEvaluater = _VisitEvaluater();
    final List<Visit> preloadedVisits = await PreloadedVisitsStorageManager.getVisitsByProjectId(projectId);
    for(Visit v in preloadedVisits){
      await _evaluateVisit(v, projectId, accessToken);
    }
    await _endPreloadedProjectIfFinished(projectId);
    _resetVisitEvaluater();
  }

  Future<void> _evaluateVisit(Visit visit, int projectId, String accessToken)async{
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

  Future<void> evaluatePreloadedVisit(Visit visit, int projectId, String accessToken)async{
    
    if(visit.completo){
      final List<Formulario> preloadedForms = await PreloadedFormsStorageManager.getPreloadedFormsByVisitId(visit.id);
      for(Formulario f in preloadedForms){
        await _evaluateForm(f, visit.id, accessToken);
      }
      await _endPreloadedVisitIfFinished(visit.id, projectId);
    }
  }

  Future<void> _evaluateForm(Formulario f, int visitId, String accessToken)async{
    await _formEvaluater.evaluatePreloadedForm(f, visitId, accessToken);
    visitIsFinished = _formEvaluater.formIsFinished? visitIsFinished : false;
  }

  Future<void> _endPreloadedVisitIfFinished(int visitId, int projectId)async{
    if(visitIsFinished){
      await _endPreloadedVisit(visitId, projectId);
    }
  }

  Future<void> _endPreloadedVisit(int visitId, int projectId)async{
    //TODO: postCommentedImagesToBack(v); ??
    PreloadedVisitsStorageManager.removeVisit(visitId, projectId);
  }
}

class _FormEvaluater{
  String _accessToken;
  bool formIsFinished;

  Future<void> evaluatePreloadedForm(Formulario form, int visitId, String accessToken)async{
    _accessToken = accessToken;
    if(form.completo){
      await _evaluateFinishedPreloadedForm(form, visitId);
    }else{
      formIsFinished = false;
    }
  }

  Future<void> _evaluateFinishedPreloadedForm(Formulario form, int visitId)async{
    try{
      await _endPreloadedForm(form, visitId);
      formIsFinished = true;
    }catch(err){
      formIsFinished = false;
    }
  }

  Future<void> _endPreloadedForm(Formulario form, int visitId)async{
    await _sendFormIfTieneCampos(form, visitId);
    await _sendFirmersIfTieneFirmers(form, visitId);
    await PreloadedFormsStorageManager.removePreloadedForm(form.id, visitId);
  }

  Future _sendFormIfTieneCampos(Formulario form, int visitId)async{
    if(_formTieneCampos(form))
      await ProjectsServicesManager.updateForm(form, visitId, _accessToken);
  }

  Future _sendFirmersIfTieneFirmers(Formulario form, int visitId)async{
    if(_formTieneFirmers(form))
      await _sendFirmers(form, visitId);
  }

  bool _formTieneCampos(Formulario form){
    return form.campos!=null && form.campos.length > 0;
  }

  bool _formTieneFirmers(Formulario form){
    return form.firmers.length > 0;
  }

  Future _sendFirmers(Formulario form, int visitId)async{
    for(PersonalInformation firmer in form.firmers){
      await ProjectsServicesManager.saveFirmer(_accessToken, firmer, form.id, visitId);
    }
  }
}