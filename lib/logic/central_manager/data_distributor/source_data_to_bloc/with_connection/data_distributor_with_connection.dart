import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/central_manager/data_distributor/source_data_to_bloc/data_distributor.dart';
import 'package:gap/logic/services_manager/forms_services_manager.dart';
import 'package:gap/logic/services_manager/projects_services_manager.dart';
import 'package:gap/logic/services_manager/visits_services_manager.dart';
import 'package:gap/logic/storage_managers/forms/formularios_storage_manager.dart';
import 'package:gap/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/preloaded_visits_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';

class DataDistributorWithConnection extends DataDistributor{
  
  @override
  Future<void> updateProjects()async{
    final ProjectsBloc pBloc = blocsAsMap[BlocName.Projects];
    await ProjectsServicesManager.loadProjects(pBloc); 
  }

  @override
  Future<void> updateChosenProject(Project project)async{
    super.updateChosenProject(project);
    ProjectsStorageManager.setChosenProject(project);
  }

  @override
  Future<void> updateChosenVisit(Visit visit)async{
    await super.addChosenVisitToBloc(visit);
    _addPreloadedDataRelatedToChosenProject(visit);
    await _loadFormsByChosenVisits(visit.id);
    await _addVisitToStorage(visit);
  }

  Future _addPreloadedDataRelatedToChosenProject(Visit visit)async{
    final Project chosenProject = UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail];
    await ProjectsStorageManager.setProjectWithPreloadedVisits(chosenProject);
    await PreloadedVisitsStorageManager.setVisit(visit, chosenProject.id);
  }

  Future _loadFormsByChosenVisits(int visitId)async{
    final FormulariosBloc fBloc = blocsAsMap[BlocName.Formularios];
    final List<Formulario> forms = await FormsServicesManager.loadForms(fBloc, visitId);
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
  Future<void> updateVisits()async{
    final VisitsBloc vBloc = blocsAsMap[BlocName.Visits];
    await VisitsServicesManager.loadVisits(vBloc);
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
    final Project chosenProject = pBloc.state.chosenProject;
    await PreloadedVisitsStorageManager.removeVisit(visit.id, chosenProject.id);
  }

  Future _removeFormsFromStorage()async{
    await FormulariosStorageManager.removeForms();
  }
}