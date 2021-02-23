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

class DataDistributorWithConnection extends DataDistributor{
  
  @override
  Future<void> updateProjects()async{
    final ProjectsBloc pBloc = blocsAsMap[BlocName.Projects];
    await ProjectsServicesManager.loadProjects(pBloc);
  }

  @override
  Future<void> updateChosenProject([Entity entityToAdd])async{
    await addChosenProjectToBloc(entityToAdd);
    await ProjectsStorageManager.setProjectWithPreloadedVisits(entityToAdd);
  }

  @override
  Future<void> updateChosenVisit(Visit visit)async{
    await addChosenVisitToBloc(visit);
    await _loadFormsByChosenVisits(visit.id);
    await _addChosenVisitIntoPreloadedStorage(visit);
  }

  Future _loadFormsByChosenVisits(int visitId)async{
    final FormulariosBloc fBloc = blocsAsMap[BlocName.Formularios];
    await FormsServicesManager.loadForms(fBloc, visitId);
  }

  Future _addChosenVisitIntoPreloadedStorage(Visit visit)async{
    final Project chosenProject = UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail];
    await PreloadedVisitsStorageManager.setVisit(visit, chosenProject.id);
  }

  @override
  Future<void> updateVisits()async{
    final VisitsBloc vBloc = blocsAsMap[BlocName.Visits];
    await VisitsServicesManager.loadVisits(vBloc);
  }

  @override
  Future<void> updateFormularios()async{
    final FormulariosBloc fBloc = blocsAsMap[BlocName.Formularios];
    //await FormsServicesManager.loadForms(fBloc);
    final Visit chosenVisit = UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail];
    final List<Formulario> formularios = await FormulariosStorageManager.getForms();
    for(Formulario form in formularios){
      await PreloadedFormsStorageManager.setPreloadedForm(form, chosenVisit.id);
    }
  }

  @override
  Future resetForms()async{
    final VisitsBloc vBloc = blocsAsMap[BlocName.Visits];
    final Visit chosenVisit = vBloc.state.chosenVisit;
    await _removeVisitFromPreloadedVisitsIfCompleted(chosenVisit);
        
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
}