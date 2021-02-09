import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageConnectorSingleton{
  static final StorageConnectorSingleton _sCSingleton = StorageConnectorSingleton._internal();
  StorageConnectorSingleton._internal();
  factory StorageConnectorSingleton(){
    return _sCSingleton;
  }

  static final StorageConnector storageConnector = StorageConnector();
}

class StorageConnector{
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
  
  @protected
  Future<void> write(String key, String value)async{
    await _fss.write(key: key, value: value);
  }
  
  @protected
  Future<String> read(String key)async{
    return await _fss.read(key: key)??'';
  }
  
  @protected
  Future<void> delete(String key)async{
    await _fss.delete(key: key);
  }
}