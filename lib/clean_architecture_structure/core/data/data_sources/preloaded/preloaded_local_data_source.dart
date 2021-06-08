import 'package:gap/clean_architecture_structure/core/data/data_sources/preloaded/preloaded_data_model.dart';
import 'package:gap/clean_architecture_structure/features/muestras/data/models/muestreo_model.dart';
import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/data/models/formulario/formulario_model.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';

abstract class PreloadedLocalDataSource{
  Future<void> setPreloadedFamily(int projectId, int visitId, List<FormularioModel> formularios, MuestreoModel muestreo);
  Future<List<int>> getPreloadedProjectsIds();
  Future<List<int>> getPreloadedVisitsIds(int projectId);
  Future<List<FormularioModel>> getPreloadedFormularios(int projectId, int visitId);
  Future<void> updatePreloadedFormulario(int projectId, int visitId, FormularioModel formulario);
  Future<void> removePreloadedFormulario(int projectId, int visitId, int formularioId);
  Future<MuestreoModel> getMuestreo(int projectId, int visitId);
  Future<void> updateMuestreo(int projectId, int visitId, MuestreoModel muestreo);
  Future<void> removeMuestreo(int projectId, int visitId, int muestreoId);

  Future<void> setPreloadedFamilyOld(int projectId, int visitId, List<FormularioModel> formularios, [MuestreoModel muestreo, FormularioModel preFormulario, FormularioModel posFormulario]);
  Future<List<int>> getPreloadedProjectsIdsOld(); 
  Future<List<int>> getPreloadedVisitsIdsOld(int projectId);
  Future<List<FormularioModel>> getPreloadedFormulariosOld(int projectId, int visitId);
  Future<void> updatePreloadedFormularioOld(int projectId, int visitId, FormularioModel formulario);
  Future<void> removePreloadedFormularioOld(int formularioId);
  Future<void> deleteAll();
}

class PreloadedLocalDataSourceImpl implements PreloadedLocalDataSource{
  static const PRELOADED_DATA_STORAGE_KEY = 'preloaded_data';
  final StorageConnector storageConnector;

  PreloadedLocalDataSourceImpl({
    @required this.storageConnector
  });

  @override
  Future<void> setPreloadedFamily(int projectId, int visitId, List<FormularioModel> formularios, MuestreoModel muestreo)async{
    final Map<String, dynamic> jsonPreloadedData = await storageConnector.getMap(PRELOADED_DATA_STORAGE_KEY);
    final PreloadedDataModel preloadedData = PreloadedDataModel.fromJson(jsonPreloadedData);
    preloadedData.setVisitData(projectId, visitId, formularios, muestreo);
    await storageConnector.setMap(preloadedData.toJson(), PRELOADED_DATA_STORAGE_KEY);
  }

  Future<List<int>> getPreloadedProjectsIds()async{
    final Map<String, dynamic> jsonPreloadedData = await storageConnector.getMap(PRELOADED_DATA_STORAGE_KEY);
    final PreloadedDataModel preloadedData = PreloadedDataModel.fromJson(jsonPreloadedData);
    _cleanPreloadedData(preloadedData);
    return preloadedData.projects.keys.map(
      (k) => int.parse(k)
    ).toList();
  }

  void _cleanPreloadedData(PreloadedDataModel preloadedData){
    preloadedData.projects.forEach((key, p) { 
      p.visits.removeWhere((key, v) => 
        (v.formularios == null || v.formularios.isEmpty ) && v.muestreo == null);
    });
    preloadedData.projects.removeWhere((key, p) => p.visits.isEmpty);
  }

  Future<List<int>> getPreloadedVisitsIds(int projectId)async{
    final Map<String, dynamic> jsonPreloadedData = await storageConnector.getMap(PRELOADED_DATA_STORAGE_KEY);
    final PreloadedDataModel preloadedData = PreloadedDataModel.fromJson(jsonPreloadedData);
    final PreloadedProjectModel project = preloadedData.projects['$projectId'];
    _cleanPreloadedData(preloadedData);
    if(project != null)
      return project.visits.keys.map((k) => int.parse(k)).toList();
    else
      return [];
  }

  Future<List<FormularioModel>> getPreloadedFormularios(int projectId, int visitId)async{
    final Map<String, dynamic> jsonPreloadedData = await storageConnector.getMap(PRELOADED_DATA_STORAGE_KEY);
    final PreloadedDataModel preloadedData = PreloadedDataModel.fromJson(jsonPreloadedData);
    final PreloadedVisitModel visitData = preloadedData.getVisitData(projectId, visitId);
    if(visitData != null)
      return visitData.formularios;
    return [];
  }

  Future<void> updatePreloadedFormulario(int projectId, int visitId, FormularioModel formulario)async{
    final Map<String, dynamic> jsonPreloadedData = await storageConnector.getMap(PRELOADED_DATA_STORAGE_KEY);
    final PreloadedDataModel preloadedData = PreloadedDataModel.fromJson(jsonPreloadedData);
    final PreloadedVisitModel visitData = preloadedData.getVisitData(projectId, visitId);
    if(visitData != null){
      final int formIndex = visitData.formularios.indexWhere((f) => f.id == formulario.id);
      if(formIndex != -1)
        visitData.formularios[formIndex] = formulario;
    }
  }

  Future<void> removePreloadedFormulario(int projectId, int visitId, int formularioId)async{
    final Map<String, dynamic> jsonPreloadedData = await storageConnector.getMap(PRELOADED_DATA_STORAGE_KEY);
    final PreloadedDataModel preloadedData = PreloadedDataModel.fromJson(jsonPreloadedData);
    final PreloadedVisitModel visitData = preloadedData.getVisitData(projectId, visitId);
    if(visitData != null)
      visitData.formularios.removeWhere((f) => f.id == formularioId);
    await storageConnector.setMap(preloadedData.toJson(), PRELOADED_DATA_STORAGE_KEY);
  }

  @override
  Future<MuestreoModel> getMuestreo(int projectId, int visitId)async{
    final Map<String, dynamic> jsonPreloadedData = await storageConnector.getMap(PRELOADED_DATA_STORAGE_KEY);
    final PreloadedDataModel preloadedData = PreloadedDataModel.fromJson(jsonPreloadedData);
    final PreloadedVisitModel visitData = preloadedData.getVisitData(projectId, visitId);
    if(visitData != null)
      return visitData.muestreo;
    return null;
  }

  @override
  Future<void> updateMuestreo(int projectId, int visitId, MuestreoModel muestreo)async{
    final Map<String, dynamic> jsonPreloadedData = await storageConnector.getMap(PRELOADED_DATA_STORAGE_KEY);
    final PreloadedDataModel preloadedData = PreloadedDataModel.fromJson(jsonPreloadedData);
    final PreloadedVisitModel visitData = preloadedData.getVisitData(projectId, visitId);
    if(visitData != null)
      preloadedData.setVisitData(projectId, visitId, visitData.formularios, muestreo);
      await storageConnector.setMap(preloadedData.toJson(), PRELOADED_DATA_STORAGE_KEY);
  }
  
  @override
  Future<void> removeMuestreo(int projectId, int visitId, int muestreoId)async{
    final Map<String, dynamic> jsonPreloadedData = await storageConnector.getMap(PRELOADED_DATA_STORAGE_KEY);
    final PreloadedDataModel preloadedData = PreloadedDataModel.fromJson(jsonPreloadedData);
    final PreloadedVisitModel visitData = preloadedData.getVisitData(projectId, visitId);
    if(visitData != null)
      preloadedData.setVisitData(projectId, visitId, visitData.formularios, null);
    _cleanPreloadedData(preloadedData);
    await storageConnector.setMap(preloadedData.toJson(), PRELOADED_DATA_STORAGE_KEY);
  }

  




  @override
  Future<void> setPreloadedFamilyOld(int projectId, int visitId, List<FormularioModel> formularios, [MuestreoModel muestreo, FormularioModel preFormulario, FormularioModel posFormulario])async{
    Map<String, dynamic> preloadedData = (await storageConnector.getMap(PRELOADED_DATA_STORAGE_KEY) )??{};
    Map<String, dynamic> preloadedProject = preloadedData['$projectId']??{};
    List<Map<String, dynamic>> previousFormularios = (preloadedProject['$visitId']??[]).cast<Map<String, dynamic>>();
    preloadedProject['$visitId'] = _updatePreloadedFormularios(previousFormularios, formularios);
    preloadedProject = _getprojectDataWithoutEmptyVisits(preloadedProject);
    preloadedData['$projectId'] = preloadedProject;
    await storageConnector.setMap(preloadedData, PRELOADED_DATA_STORAGE_KEY);
  }

  List<Map<String, dynamic>> _updatePreloadedFormularios(List<Map<String, dynamic>> previousFormularios, List<FormularioModel> newFormularios){
    if(previousFormularios.length == 0)
      previousFormularios = formulariosToJson(newFormularios);
    newFormularios.forEach((nF){
      if(nF.completo)
        previousFormularios.removeWhere((pF) => pF['formulario_pivot_id'] == nF.id);
    });
    return previousFormularios;
  }

  Map<String, dynamic> _getprojectDataWithoutEmptyVisits(Map<String, dynamic> projectData){
    Map<String, dynamic> newProjectData = {};
    projectData.forEach((key, value) {
      if((value as List).isNotEmpty)
        newProjectData[key] = value;
    });
    return newProjectData;
  }

  

  @override
  Future<List<int>> getPreloadedProjectsIdsOld()async{
    Map<String, dynamic> preloadedData = await storageConnector.getMap(PRELOADED_DATA_STORAGE_KEY);
    preloadedData = _getPreloadedDataWithoutEmptyProjects(preloadedData);
    List<int> projectsIds = [];
    preloadedData.forEach((key, _) {
      projectsIds.add(int.parse(key));
    });
    return projectsIds;
  }

  @protected
  Map<String, dynamic> _getPreloadedDataWithoutEmptyProjects(Map<String, dynamic> preloadedData){
    Map<String, dynamic> cleanedPreloadedData = {};
    preloadedData.forEach((key, value) {
      if((value as Map).isNotEmpty)
        cleanedPreloadedData[key] = value;
    });
    return cleanedPreloadedData;
  }

  @override
  Future<List<int>> getPreloadedVisitsIdsOld(int projectId)async{
    final Map<String, dynamic> preloadedData = await storageConnector.getMap(PRELOADED_DATA_STORAGE_KEY);
    Map<String, dynamic> projectData = preloadedData['$projectId'];
    projectData = _getProjectDataWithoutEmptyVisits(projectData);
    List<int> visitsIds = [];
    if(projectData != null){
      projectData.forEach((key, _) {
        visitsIds.add(int.parse(key));
      });
    }
    return visitsIds;
  }

  Map<String, dynamic> _getProjectDataWithoutEmptyVisits(Map<String, dynamic> projectData){
    Map<String, dynamic> cleanedProjectData = {};
    projectData.forEach((key, value) {
      if(value!=null && (value as List).isNotEmpty)
        cleanedProjectData[key] = value;
    });
    return cleanedProjectData;
  }

  @override
  Future<List<FormularioModel>> getPreloadedFormulariosOld(int projectId, int visitId)async{
    final Map<String, dynamic> preloadedData = await storageConnector.getMap(PRELOADED_DATA_STORAGE_KEY);
    final Map<String, dynamic> projectData = preloadedData['$projectId']??{};
    final List<Map<String, dynamic>> visitData = (projectData['$visitId']??[] ).cast<Map<String, dynamic>>();
    List<FormularioModel> formularios = formulariosFromJson(visitData);
    return formularios;
  }

  @override
  Future<void> updatePreloadedFormularioOld(int projectId, int visitId, FormularioModel formulario)async{
    Map<String, dynamic> preloadedData = (await storageConnector.getMap(PRELOADED_DATA_STORAGE_KEY) )??{};
    Map<String, dynamic> projectData = preloadedData['$projectId'];
    if(projectData != null){
      List<Map<String, dynamic>> visitData = (projectData['$visitId']??[]).cast<Map<String, dynamic>>();
      //if(visitData!=null)
      _updateFormInVisitForms(visitData, formulario);
    }
    projectData = _getprojectDataWithoutEmptyVisits(projectData);
    preloadedData['$projectId'] = projectData;
    await storageConnector.setMap(preloadedData, PRELOADED_DATA_STORAGE_KEY);
  }

  void _updateFormInVisitForms(List<Map<String, dynamic>> visitForms, FormularioModel formulario){
    int formularioIndex = visitForms.indexWhere((f) => f['formulario_pivot_id'] == formulario.id);
    visitForms[formularioIndex] = formulario.toJson();
  }

  @override
  Future<void> removePreloadedFormularioOld(int formularioId)async{
    Map<String, dynamic> preloadedData = (await storageConnector.getMap(PRELOADED_DATA_STORAGE_KEY) )??{};
    preloadedData = preloadedData.map((projectId, projectData){
      return MapEntry(
        projectId,
        (projectData as Map).map((visitId, visitData){
          visitData = (visitData as List).where((f) => f['formulario_pivot_id'] != formularioId).toList();
          return MapEntry(visitId, visitData);
        })
      );
    });
    await storageConnector.setMap(preloadedData, PRELOADED_DATA_STORAGE_KEY);
  }

  Future<void> deleteAll()async{
    await storageConnector.remove(PRELOADED_DATA_STORAGE_KEY);
  }
}