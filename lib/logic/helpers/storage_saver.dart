import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageSaverSingleton{
  static final StorageSaverSingleton _storageSaverSingleton = StorageSaverSingleton._internal();
  static final StorageSaver storageSaver = StorageSaver();

  StorageSaverSingleton._internal();

  factory StorageSaverSingleton(){
    return _storageSaverSingleton;
  }
}

class StorageSaver{
  final String authTokenKey = 'auth_token';
  final String projectsKey = 'projects';
  final String chosenProjectKey = 'chosen_project';
  final String visitsKey = 'visits';
  final String chosenVisitKey = 'chosen_visit';
  final FlutterSecureStorage _fss = FlutterSecureStorage();
  
  Future<void> setStringResource(String resourceKey, String value)async{
    await write(resourceKey, value);
  }

  Future<String> getStringResource(String resourceKey)async{
    final String value = await read(resourceKey);
    return value;
  }

  Future<void> setMapResource(String resourceKey, Map<String, dynamic> value)async{
    final String valueAsString = jsonEncode(value);
    await write(resourceKey, valueAsString);
  }

  Future<Map<String, dynamic>> getMapResource(String resourceKey)async{
    final String valueAsString = await read(resourceKey);
    final Map<String, dynamic> value = jsonDecode(valueAsString).cast<String, dynamic>();
    return value;
  }

  Future<void> setListResource(String resourceKey, List<Map<String, dynamic>> value)async{
    final String valueAsString = jsonEncode(value);
    await write(resourceKey, valueAsString);
  }

  Future<List<Map<String, dynamic>>> getListResource(String resourceKey)async{
    final String valueAsString = await read(resourceKey);
    final List<Map<String, dynamic>> value = jsonDecode(valueAsString).cast<Map<String, dynamic>>();
    return value;
  }

  Future<void> removeResource(String resourceKey)async{
    await delete(resourceKey);
  }









//TODO: Pasar todos estos métodos a sus clases StorageManager correspondientes

  Future<void> setAuthToken(String authToken)async{
    final String authTokenAsString = authToken;
    await write(this.authTokenKey, authTokenAsString);
  }

  Future<String> getAuthToken()async{
    return await read(this.authTokenKey);
  }

  Future<void> deleteAuthToken()async{
    await delete(this.authTokenKey);
  }

  Future<void> setProjects(List<Map<String, dynamic>> projects)async{
    final String projectsAsString = jsonEncode(projects);
    await write(this.projectsKey, projectsAsString);
  }

  Future<List<Map<String, dynamic>>> getProjects()async{
    final List<Map<String, dynamic>> projects = await _getListOfElements(this.projectsKey);
    return projects;
  }

  Future<void> deleteProjects()async{
    await delete(this.projectsKey);
  }

  Future<void> setChosenProject(Map<String, dynamic> project)async{
    final String projectAsString = jsonEncode(project);
    await write(this.chosenProjectKey, projectAsString);
  }

  Future<Map<String, dynamic>> getChosenProject()async{
    final Map<String, dynamic> chosenProject = await _getSingleElement(this.chosenProjectKey);
    return chosenProject;
  }

  Future<void> deleteChosenProject()async{
    await delete(this.chosenProjectKey);
  }

  Future<void> setChosenVisit(Map<String, dynamic> chosenOne)async{
    final String projectAsString = jsonEncode(chosenOne);
    await write(this.chosenVisitKey, projectAsString);
  }

  Future<Map<String, dynamic>> getChosenVisit()async{
    final Map<String, dynamic> chosenOne = await _getSingleElement(this.chosenVisitKey);
    return chosenOne;
  }

  Future<void> deleteChosenVisit()async{
    await delete(this.chosenVisitKey);
  }

  Future<void> setVisits(List<Map<String, dynamic>> visits)async{
    final visitsAsString = jsonEncode(visits);
    await write(this.visitsKey, visitsAsString);
  }

  Future<List<Map<String, dynamic>>> getVisits()async{
    final List<Map<String, dynamic>> visits = await _getListOfElements(this.visitsKey);
    return visits;
  }

  Future<void> deleteVisits()async{
    await delete(this.visitsKey);
  }

  Future<List<Map<String, dynamic>>> _getListOfElements(String key)async{
    final String elementsAsString = await read(key);
    final List<Map<String, dynamic>> elements = jsonDecode(elementsAsString).cast<Map<String, dynamic>>();
    return elements;
  }

  Future<Map<String, dynamic>> _getSingleElement(String key)async{
    final String elementAsString = await read(key);
    final Map<String, dynamic> element = jsonDecode(elementAsString).cast<String, dynamic>();
    return element;
  }

  @protected
  Future<void> write(String key, String value)async{
    await _fss.write(key: key, value: value);
  }

  @protected
  Future<String> read(String key)async{
    return await _fss.read(key: key);
  }
  @protected
  Future<void> delete(String key)async{
    await _fss.delete(key: key);
  }
}