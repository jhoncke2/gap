import 'package:gap/data/enums/enums.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/projects/projects_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/central_manager/data_distributor/source_data_to_bloc/source_data_to_bloc.dart';
import 'package:gap/logic/services_manager/forms_services_manager.dart';
import 'package:gap/logic/services_manager/projects_services_manager.dart';
import 'package:gap/logic/services_manager/visits_services_manager.dart';
import 'package:gap/logic/storage_managers/forms/formularios_storage_manager.dart';
import 'package:gap/logic/storage_managers/forms/preloaded_forms_storage_manager.dart';
import 'package:gap/logic/storage_managers/projects/projects_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/preloaded_visits_storage_manager.dart';
import 'package:gap/logic/storage_managers/visits/visits_storage_manager.dart';

abstract class SourceDataToBlocWithConnection extends SourceDataToBloc{
  @override
  Future<void> updateProjects()async{
    final ProjectsBloc pBloc = blocsAsMap[BlocName.Projects];
    await ProjectsServicesManager.loadProjects(pBloc);
  }
}

class SourceDataToBlocWithConnectionInitializer extends SourceDataToBlocWithConnection{
  @override
  Future<void> updateVisits()async{
    final VisitsBloc vBloc = blocsAsMap[BlocName.Visits];
    final List<Visit> visits = await VisitsStorageManager.getVisits();
    final SetVisits svEvent = SetVisits(visits: visits);
    vBloc.add(svEvent);
  }

  @override
  Future<void> updateFormulariosBloc()async{
    final FormulariosBloc fBloc = blocsAsMap[BlocName.Formularios];
    final List<Formulario> forms = await FormulariosStorageManager.getForms();
    final SetForms sfEvent = SetForms(forms: forms);
    fBloc.add(sfEvent);
  }
}

class SourceDataToBlocWithConnectionUpdater extends SourceDataToBlocWithConnection{

  @override
  Future<void> updateChosenProject([Entity entityToAdd])async{
    await addChosenProjectToBloc(entityToAdd);
    await ProjectsStorageManager.setProjectWithPreloadedVisits(entityToAdd);
  }

  @override
  Future<void> updateChosenVisit([Entity entityToAdd])async{
    await addChosenVisitToBloc(entityToAdd);
    final Project chosenProject = UploadedBlocsData.dataContainer[NavigationRoute.ProjectDetail];
    await PreloadedVisitsStorageManager.setVisit(entityToAdd, chosenProject.id);
  }
  
  @override
  Future<void> updateChosenForm([Entity entityToAdd])async{
    await addChosenFormToBlocs(entityToAdd);
    //final Visit chosenVisit = dataAddedToBlocsByExistingNavs[NavigationRoute.VisitDetail];
    //await PreloadedFormsStorageManager.setPreloadedForm(entityToAdd, chosenVisit.id);
  }

  @override
  Future<void> updateVisits()async{
    final VisitsBloc vBloc = blocsAsMap[BlocName.Visits];
    await VisitsServicesManager.loadVisits(vBloc);
  }

  @override
  Future<void> updateFormulariosBloc()async{
    final FormulariosBloc fBloc = blocsAsMap[BlocName.Formularios];
    await FormsServicesManager.loadForms(fBloc);
    final Visit chosenVisit = UploadedBlocsData.dataContainer[NavigationRoute.VisitDetail];
    final List<Formulario> formularios = await FormulariosStorageManager.getForms();
    for(Formulario form in formularios){
      await PreloadedFormsStorageManager.setPreloadedForm(form, chosenVisit.id);
    }
  }
}