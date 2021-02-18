import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/preloaded_visits_storage_manager.dart';

class PreloadedStorageToServicesManager{
  static final _ProjectEvaluater _projectEvaluater = _ProjectEvaluater();
  
  static Future<void> sendPreloadedStorageDataToServices()async{
    final List<Project> preloadedProjects = await ProjectsStorageManager.getProjectsWithPreloadedVisits();
    for(Project p in preloadedProjects){
      await _projectEvaluater.evaluatePreloadedProject(p.id);
    }
    _resetProjectEvaluater();
  }

  static void _resetProjectEvaluater(){
    _projectEvaluater.projectIsFinished = true;
  }
}

class _ProjectEvaluater{
  final _VisitEvaluater _visitEvaluater = _VisitEvaluater();
  bool projectIsFinished = true;

  Future<void> evaluatePreloadedProject(int projectId)async{
    final List<Visit> preloadedVisits = await PreloadedVisitsStorageManager.getVisitsByProjectId(projectId);
    for(Visit v in preloadedVisits){
      await _evaluateVisit(v.id, projectId);
    }
    await _endPreloadedProjectIfFinished(projectId);
    _resetVisitEvaluater();
  }

  Future<void> _evaluateVisit(int visitId, int projectId)async{
    await _visitEvaluater.evaluatePreloadedVisit(visitId, projectId);
    projectIsFinished = _visitEvaluater.visitIsFinished? projectIsFinished : false;
  }

  Future<void> _endPreloadedProjectIfFinished(int projectId)async{
    if(projectIsFinished){
      await ProjectsStorageManager.removeProjectWithPreloadedVisits(projectId);
    }
  }

  void _resetVisitEvaluater(){
    _visitEvaluater.visitIsFinished = true;
  }
}


class _VisitEvaluater{
  final _FormEvaluater _formEvaluater = _FormEvaluater();
  bool visitIsFinished = true;

  Future<void> evaluatePreloadedVisit(int visitId, int projectId)async{
    final List<Formulario> preloadedForms = await PreloadedFormsStorageManager.getPreloadedFormsByVisitId(visitId);
    for(Formulario f in preloadedForms){
      await _evaluateForm(f, visitId);
    }
    await _endPreloadedVisitIfFinished(visitId, projectId);
  }

  Future<void> _evaluateForm(Formulario f, int visitId)async{
    await _formEvaluater.evaluatePreloadedForm(f, visitId);
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
  bool formIsFinished;

  Future<void> evaluatePreloadedForm(Formulario form, int visitId)async{
    if(form.stage == ProcessStage.Realizada){
      await _evaluateFinishedPreloadedForm(form, visitId);
    }else{
      formIsFinished = false;
    }
  }

  Future<void> _evaluateFinishedPreloadedForm(Formulario form, int visitId)async{
    await _endPreloadedForm(form, visitId);
    formIsFinished = true;
  }

  Future<void> _endPreloadedForm(Formulario form, int visitId)async{
    //TODO: postFormToBack(f);
    PreloadedFormsStorageManager.removePreloadedForm(form.id, visitId);
  }
}