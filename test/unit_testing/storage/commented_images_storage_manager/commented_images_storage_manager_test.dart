import 'package:flutter_test/flutter_test.dart';
import 'package:gap/logic/storage_managers/commented_images/commented_images_storage_manager.dart';
import 'package:gap/native_connectors/storage_connector.dart';

import '../../../mock/storage/mock_flutter_secure_storage.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/data/fake_data/fake_data.dart' as fakeData;
import './commented_images_storage_manager_descriptions.dart' as descriptions;

final CommentedImagesStorageManager ciSM = CommentedImagesStorageManager();

main(){

  _initStorageConnector();
  group(descriptions.commentedImagesGroupDescription, (){
    _testSetCommentedImages();
    _testGetCommentedImages();
    _testRemoveCommentedImages();
  });
}

void _initStorageConnector(){
  // ignore: invalid_use_of_protected_member
  StorageConnectorSingleton.storageConnector.fss = MockFlutterSecureStorage();
}

void _testSetCommentedImages(){
  test(descriptions.testSetCommentedImagesDescription, ()async{
    try{
      await _tryTestSetCommentedImages();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestSetCommentedImages()async{
  await CommentedImagesStorageManager.setCommentedImages(fakeData.commentedImages);
}

void _testGetCommentedImages(){
  test(descriptions.testGetCommentedImagesDescription, ()async{   
    try{
      await _tryTestGetCommentedImages();
    }catch(err){
      throw err;
    }
  });
}

Future<void> _tryTestGetCommentedImages()async{
  final List<CommentedImage> commentedImages = await CommentedImagesStorageManager.getCommentedImages();
  _verifyStorageGetReturnedElements(commentedImages);
}

void _verifyStorageGetReturnedElements(List<dynamic> storageReturnedElements){
  expect(storageReturnedElements, isNotNull, reason: 'Las commentedImages retornados por el storageManager no deben ser null');
  expect(storageReturnedElements.length, fakeData.commentedImages.length, reason: 'El length de las commentedImages retornados por el storageManager debe ser el mismo que el de los fake');
  for(int i = 0; i < storageReturnedElements.length; i++){
    _compararParDeCommentedImages(storageReturnedElements[i], fakeData.commentedImages[i]);
  }
}

void _compararParDeCommentedImages(CommentedImage i1, CommentedImage i2){
  expect(i1.commentary, i2.commentary, reason: 'El commentary del current CommentedImage del storageManager debe ser el mismo que el de los fakeCommentedImages');
  expect(i1.image.toString(), i2.image.toString(), reason: 'El image del current CommentedImage del storageManager debe ser el mismo que el de los fakeCommentedImages');
  expect(i1.positionInPage, i2.positionInPage, reason: 'El positionInPage del current CommentedImage del storageManager debe ser el mismo que el de los fakeCommentedImages');
}

void _testRemoveCommentedImages(){
  test(descriptions.testRemoveCommentedImagesDescription, ()async{
    try{
      await _tryTestRemoveCommentedImages();
    }catch(err){
      fail('Ocurrió un error: $err');
    }
  });
}

Future<void> _tryTestRemoveCommentedImages()async{
  await CommentedImagesStorageManager.removeCommentedImages();
}