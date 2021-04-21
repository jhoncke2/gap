import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/*
  La clas StorageConnector está hecho de esta forma y no como una clase estáticapara facilidad de los tests
*/
class StorageConnectorOldSingleton{
  static final StorageConnectorOld storageConnector = StorageConnectorOld();
}

class StorageConnectorOld{
  @protected
  FlutterSecureStorage fss = FlutterSecureStorage();
  
  Future<void> setStringResource(String resourceKey, String value)async{
    await write(resourceKey, value);
  }

  Future<String> getStringResource(String resourceKey)async{
    final String value = await read(resourceKey);
    return value;
  }

  Future<void> setMapResource(String resourceKey, Map<dynamic, dynamic> value)async{
    final String valueAsString = jsonEncode(value);
    await write(resourceKey, valueAsString);
  }

  Future<Map<dynamic, dynamic>> getMapResource(String resourceKey)async{
    final String valueAsString = await read(resourceKey);
    final Map<String, dynamic> value = jsonDecode(valueAsString??'{}').cast<String, dynamic>();
    return value;
  }

  Future<void> setListResource(String resourceKey, List<Map<String, dynamic>> value)async{
    final String valueAsString = jsonEncode(value);
    await write(resourceKey, valueAsString);
  }

  Future<List<Map<String, dynamic>>> getListResource(String resourceKey)async{
    final String valueAsString = await read(resourceKey);
    final List<Map<String, dynamic>> value = jsonDecode(valueAsString??'[]').cast<Map<String, dynamic>>();
    return value;
  }

  Future<void> removeResource(String resourceKey)async{
    await delete(resourceKey);
  }
  
  @protected
  Future<void> write(String key, String value)async{
    await fss.write(key: key, value: value);
  }
  
  @protected
  Future<String> read(String key)async{
    return (await fss.read(key: key));
  }
  
  @protected
  Future<void> delete(String key)async{
    await fss.delete(key: key);
  }

  Future deleteAll()async{
    await fss.deleteAll();
  }
}