import 'package:flutter_test/flutter_test.dart';
import 'package:gap/logic/bloc/widgets/commented_images/commented_images_storage_manager.dart';
import 'package:gap/native_connectors/storage_connector.dart';

import '../../../mock/storage/mock_flutter_secure_storage.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import './commented_images_storage_manager_descriptions.dart' as descriptions;

final CommentedImagesStorageManager ciSM = CommentedImagesStorageManager();

main(){

  _initStorageConnector();
  group(descriptions.commentedImagesGroupDescription, (){
    _testSetForms();
    _testGetForms();
    _testRemoveForms();
  });
}

void _initStorageConnector(){
  // ignore: invalid_use_of_protected_member
  StorageConnectorSingleton.storageConnector.fss = MockFlutterSecureStorage();
}

void _testSetForms(){
  test(descriptions.testSetCommentedImagesDescription, ()async{
    try{
      await _tryTestSetForms();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestSetForms()async{
  await CommentedImagesStorageManager.setCommentedImages(fakeData.commentedImages);
}

void _testGetForms(){
  test(descriptions.testGetCommentedImagesDescription, ()async{   
    try{
      await _tryTestGetForms();
    }catch(err){
      throw err;
    }
  });
}

Future<void> _tryTestGetForms()async{
  final List<CommentedImage> visits = await CommentedImagesStorageManager.getCommentedImages();
  _verifyStorageGetReturnedElements(visits);
}

void _verifyStorageGetReturnedElements(List<dynamic> storageReturnedElements){
  expect(storageReturnedElements, isNotNull, reason: 'Las commentedImages retornados por el storageManager no deben ser null');
  expect(storageReturnedElements.length, fakeData.formularios.length, reason: 'El length de las commentedImages retornados por el storageManager debe ser el mismo que el de los fake');
  for(int i = 0; i < storageReturnedElements.length; i++){
    _compararParDeForms(storageReturnedElements[i], fakeData.commentedImages[i]);
  }
}

void _compararParDeForms(CommentedImage i1, CommentedImage i2){
  expect(i1.commentary, i2.commentary, reason: 'El commentary del current CommentedImage del storageManager debe ser el mismo que el de los fakeCommentedImages');
  expect(i1.image.toString(), i2.image.toString(), reason: 'El image del current CommentedImage del storageManager debe ser el mismo que el de los fakeCommentedImages');
  expect(i1.positionInPage, i2.positionInPage, reason: 'El positionInPage del current CommentedImage del storageManager debe ser el mismo que el de los fakeCommentedImages');
}

void _testRemoveForms(){
  test(descriptions.testRemoveCommentedImagesDescription, ()async{
    try{
      await _tryTestRemoveForms();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemoveForms()async{
  await CommentedImagesStorageManager.removeCommentedImages();
}