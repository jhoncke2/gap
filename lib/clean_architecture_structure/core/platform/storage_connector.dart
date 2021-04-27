import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:meta/meta.dart';

abstract class StorageConnector{
  Future<void> setString(String string, String key);
  Future<String> getString(String key);
  Future<void> setMap(Map<String, dynamic> map, String key);
  Future<Map<String, dynamic>> getMap(String key);
  Future<void> setList(List<Map<String, dynamic>> list, String key);
  Future<List<Map<String, dynamic>>> getList(String key);
  Future<void> remove(String key);
  Future<void> removeAll();
}

class StorageConnectorImpl implements StorageConnector{

  final FlutterSecureStorage fss;
  StorageConnectorImpl({
    @required this.fss
  });

  @override
  Future<void> setString(String string, String key)async{
    await _write(string, key);
  }

  @override
  Future<String> getString(String key)async{
    return await _read(key)??'';
  }

  @override
  Future<void> setMap(Map<String, dynamic> map, String key)async{
    final String jsonString = jsonEncode(map);
    await _write(jsonString, key);
  }

  @override
  Future<Map<String, dynamic>> getMap(String key)async{
    final String jsonString = await _read(key);
    return jsonDecode(jsonString??'{}');
  }

  @override
  Future<void> setList(List<Map<String, dynamic>> list, String key)async{
    final String listString = jsonEncode(list);
    await _write(listString, key);
  }

  @override
  Future<List<Map<String, dynamic>>> getList(String key)async{
    final String listString = await _read(key);
    if([null, ''].contains(listString))
      return [];
    else
      return jsonDecode(listString).cast<Map<String, dynamic>>();
  }

  @override
  Future<void> remove(String key)async{
    await _remove(key);
  }

  @override
  Future<void> removeAll()async{
    await executeStorageFunction(()async{
      await fss.deleteAll();
    });
  }

  Future<void> _write(String value, String key)async{
    await executeStorageFunction(
      ()async{
        await fss.write(key: key, value: value);
      }
    );
  }
  
  Future<String> _read(String key)async{
    return await executeStorageFunction(
      ()async{
        return await fss.read(key: key);
      }
    );
  }

  Future<void> _remove(String key)async{
    await executeStorageFunction(
      ()async{
        await fss.delete(key: key);
      }
    );
  }
  
  Future executeStorageFunction(Function function)async{
    try{
      return await function();
    }on PlatformException catch(_){
      throw StorageException(type: StorageExceptionType.PLATFORM);
    }catch(_){
      throw StorageException(type: StorageExceptionType.NORMAL);
    }
  }
}