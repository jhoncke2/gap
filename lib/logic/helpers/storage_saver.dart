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
  final String visitsKey = 'visits';  
  final FlutterSecureStorage _fss = FlutterSecureStorage();
  
  void testFSS(){
  }

  Future<void> setAuthToken(String authToken)async{
    await write(this.authTokenKey, authToken);
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