
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import 'package:test/test.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage{

}

StorageConnectorImpl storageConnector;
MockFlutterSecureStorage fss;
String tStorageKey;


void main(){
  
  setUp((){
    fss = MockFlutterSecureStorage();
    storageConnector = StorageConnectorImpl(fss: fss);
    tStorageKey = 'test_storage_key'; 
  });
  
  _testGroupSetString();
  _testGroupGetString();
  _testGroupSetMap();
  _testGroupGetMap();
  _testGroupSetList();
  _testGroupGetList();
  _testGroupRemove();
  _testGroupDeleteAll();
}

void _testGroupSetString(){
  group('setString', (){
    final String tString = 'string';
    test('should successfully save a string', ()async{
      await storageConnector.setString(tString, tStorageKey);
      verify(fss.write(key: tStorageKey, value: tString));
    });

    test('should throw an StorageException when fss fails writing', ()async{
      when(fss.write(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(Exception());
      final call = storageConnector.setString;
      expect(()=>call(tString, tStorageKey), throwsA(TypeMatcher<StorageException>()));
    });

    test('should throws a StorageException of type Platform when fss throws a PlatformException', ()async{
      when(fss.write(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(PlatformException(code: '1'));
      try{
        await storageConnector.setString(tString, tStorageKey);
      }on StorageException catch(err){
        expect(err.type, StorageExceptionType.PLATFORM);
      }catch(_){
        fail('el error deberia ser de type platform');
      }
    });
  });
}

void _testGroupGetString(){
  group('getString', (){
    final String tString = 'string';
    test('should successfully get a string', ()async{
      when(fss.read(key: anyNamed('key'))).thenAnswer((realInvocation) async => tString);
      final String response = await storageConnector.getString(tStorageKey);
      verify(fss.read(key: tStorageKey));
      expect(response, equals(tString));
    });

    test('should throw an StorageException when fss fails reading', ()async{
      when(fss.read(key: anyNamed('key'))).thenThrow(Exception());
      final call = storageConnector.getString;
      expect(()=>call(tStorageKey), throwsA(TypeMatcher<StorageException>()));
    });

    test('should throws a StorageException of type Platform when fss throws a PlatformException', ()async{
      when(fss.read(key: anyNamed('key'))).thenThrow(PlatformException(code: '1'));
      try{
        await storageConnector.getString(tStorageKey);
      }on StorageException catch(err){
        expect(err.type, StorageExceptionType.PLATFORM);
      }catch(_){
        fail('el error deberia ser de type platform');
      }
    });
  });
}

void _testGroupSetMap(){
  group('setMap', (){
    Map<String, dynamic> tMap = {'key1':'value1', 'key2':2};
    test('should successfuly save a map', ()async{
      await storageConnector.setMap(tMap, tStorageKey);
      verify(fss.write(key: tStorageKey, value: jsonEncode(tMap)));
    });

    test('should throw an StorageException when fss fails writing', ()async{
      when(fss.write(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(Exception());
      final call = storageConnector.setMap;
      expect(()=>call(tMap, tStorageKey), throwsA(TypeMatcher<StorageException>()));
    });

    test('should throws a StorageException of type Platform when fss throws a PlatformException', ()async{
      when(fss.write(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(PlatformException(code: '1'));
      try{
        await storageConnector.setMap(tMap, tStorageKey);
      }on StorageException catch(err){
        expect(err.type, StorageExceptionType.PLATFORM);
      }catch(_){
        fail('el error deberia ser de type platform');
      }
    });
  });
}

void _testGroupGetMap(){
  group('getMap', (){
    Map<String, dynamic> tMap = {'key1':'value1', 'key2':2};
    test('should successfully get a string', ()async{
      when(fss.read(key: anyNamed('key'))).thenAnswer((realInvocation) async => jsonEncode(tMap));
      final Map<String, dynamic> response = await storageConnector.getMap(tStorageKey);
      verify(fss.read(key: tStorageKey));
      expect(response, equals(tMap));
    });

    test('should throw an StorageException when fss fails reading', ()async{
      when(fss.read(key: anyNamed('key'))).thenThrow(Exception());
      final call = storageConnector.getMap;
      expect(()=>call(tStorageKey), throwsA(TypeMatcher<StorageException>()));
    });

    test('should throws a StorageException of type Platform when fss throws a PlatformException', ()async{
      when(fss.read(key: anyNamed('key'))).thenThrow(PlatformException(code: '1'));
      try{
        await storageConnector.getMap(tStorageKey);
      }on StorageException catch(err){
        expect(err.type, StorageExceptionType.PLATFORM);
      }catch(_){
        fail('el error deberia ser de type platform');
      }
    });
  });  
}

void _testGroupSetList(){
  group('setList', (){
    List<Map<String, dynamic>> tList = [{'key1':'value1', 'key2':2}, {'key1':'x'}];
    test('should successfuly save a list', ()async{
      await storageConnector.setList(tList, tStorageKey);
      verify(fss.write(key: tStorageKey, value: jsonEncode(tList)));
    });

    test('should throw an StorageException when fss fails writing', ()async{
      when(fss.write(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(Exception());
      final call = storageConnector.setList;
      expect(()=>call(tList, tStorageKey), throwsA(TypeMatcher<StorageException>()));
    });

    test('should throws a StorageException of type Platform when fss throws a PlatformException', ()async{
      when(fss.write(key: anyNamed('key'), value: anyNamed('value'))).thenThrow(PlatformException(code: '1'));
      try{
        await storageConnector.setList(tList, tStorageKey);
      }on StorageException catch(err){
        expect(err.type, StorageExceptionType.PLATFORM);
      }catch(_){
        fail('el error deberia ser de type platform');
      }
    });
  });
}

void _testGroupGetList(){
  group('getList', (){
    List<Map<String, dynamic>> tList = [{'key1':'value1', 'key2':2}, {'key1':'x'}];
    test('should successfully get a list', ()async{
      when(fss.read(key: anyNamed('key'))).thenAnswer((realInvocation) async => jsonEncode(tList));
      final List<Map<String, dynamic>> response = await storageConnector.getList(tStorageKey);
      verify(fss.read(key: tStorageKey));
      expect(response, equals(tList));
    });

    test('should return a empty list when it comes null from storage', ()async{
      when(fss.read(key: anyNamed('key'))).thenAnswer((realInvocation) async => null);
      final response = await storageConnector.getList(tStorageKey);
      expect(response, []);
    });

    test('should throw an StorageException when fss fails reading', ()async{
      when(fss.read(key: anyNamed('key'))).thenThrow(Exception());
      final call = storageConnector.getList;
      expect(()=>call(tStorageKey), throwsA(TypeMatcher<StorageException>()));
    });

    test('should throws a StorageException of type Platform when fss throws a PlatformException', ()async{
      when(fss.read(key: anyNamed('key'))).thenThrow(PlatformException(code: '1'));
      try{
        await storageConnector.getList(tStorageKey);
      }on StorageException catch(err){
        expect(err.type, StorageExceptionType.PLATFORM);
      }catch(_){
        fail('el error deberia ser de type platform');
      }
    });
  });
}

void _testGroupRemove(){
  group('remove', (){
    test('should remove successfuly', ()async{
      await storageConnector.remove(tStorageKey);
      verify(fss.delete(key: tStorageKey));
    });

    test('should throws a StorageException when fss fails deleting', ()async{
      when(fss.delete(key: anyNamed('key'))).thenThrow(Exception());
      final call = storageConnector.remove;
      expect(()=>call(tStorageKey), throwsA(TypeMatcher<StorageException>()));
    });

    test('should throws a StorageException of type Platform when fss throws a PlatformException', ()async{
      when(fss.delete(key: anyNamed('key'))).thenThrow(PlatformException(code: '1'));
      try{
        await storageConnector.remove(tStorageKey);
      }on StorageException catch(err){
        expect(err.type, StorageExceptionType.PLATFORM);
      }catch(_){
        fail('el error deberia ser de type platform');
      }
    });
  });
}

void _testGroupDeleteAll(){
  group('removeAll', (){
    test('should execute removeAll successfuly', ()async{
      await storageConnector.removeAll();
      verify(fss.deleteAll());
    });

    test('should throws a StorageException when fss doesnt work fine', ()async{
      when(fss.deleteAll()).thenThrow(Exception());
      final call = storageConnector.removeAll;
      expect(()=>call(), throwsA(TypeMatcher<StorageException>()));
    });
  });
}