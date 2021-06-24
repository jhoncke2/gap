import 'dart:io';
import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/commented_images/commented_images_remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/projects/projects_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/user/user_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/visits/visits_local_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/commented_image_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/project_model.dart';
import 'package:gap/clean_architecture_structure/core/data/models/visit_model.dart';
import 'package:gap/clean_architecture_structure/core/data/repositories/commented_images_repository.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/commented_image.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:gap/clean_architecture_structure/core/error/failures.dart';
import 'package:gap/clean_architecture_structure/core/network/network_info.dart';
import '../../../fixtures/fixture_reader.dart';

class MockNetworkInfo extends Mock implements NetworkInfo{}
class MockCommentedImagesRemoteDataSource extends Mock implements CommentedImagesRemoteDataSource{}
class MockUserLocalDataSource extends Mock implements UserLocalDataSource{}
class MockProjectsLocalDataSource extends Mock implements ProjectsLocalDataSource{}
class MockVisitsLocalDataSource extends Mock implements VisitsLocalDataSource{}

CommentedImagesRepositoryImpl repository;
MockNetworkInfo networkInfo;
MockCommentedImagesRemoteDataSource remoteDataSource;
MockUserLocalDataSource userLocalDataSource;
MockProjectsLocalDataSource projectsLocalDataSource;
MockVisitsLocalDataSource visitsLocalDataSource;

void main() {
  setUp((){
    networkInfo = MockNetworkInfo();     
    remoteDataSource =  MockCommentedImagesRemoteDataSource(); 
    userLocalDataSource = MockUserLocalDataSource(); 
    projectsLocalDataSource = MockProjectsLocalDataSource(); 
    visitsLocalDataSource = MockVisitsLocalDataSource();
    repository = CommentedImagesRepositoryImpl(
      networkInfo: networkInfo, 
      remoteDataSource: remoteDataSource, 
      userLocalDataSource: userLocalDataSource, 
      projectsLocalDataSource: projectsLocalDataSource, 
      visitsLocalDataSource: visitsLocalDataSource
    );
  });

  group('setCommentedImages', (){
    String tAccessToken;
    List<UnSentCommentedImage> tCommentedImages;
    ProjectModel tChosenProject;
    VisitModel tChosenVisit;
    setUp((){
      tAccessToken = 'a_t';
      tCommentedImages = _getUnsentCommentedImagesFromFixture();
      tChosenProject = ProjectModel(id: 1, nombre: 'asdf');
      tChosenVisit = VisitModel(id: 2, completo: false, formularios: [], hasMuestreo: false, date: null, sede: null, firmers: []);
    });

    test('should set the commImgs on the remoteDataSource with the accessToken and visitId when there is connectivity', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      await repository.setCommentedImages(tCommentedImages);
      verify(networkInfo.isConnected());      
      verify(userLocalDataSource.getAccessToken());
      verify(projectsLocalDataSource.getChosenProject());
      verify(visitsLocalDataSource.getChosenVisit(tChosenProject.id));
      verify(remoteDataSource.setCommentedImages(tCommentedImages, tChosenVisit.id, tAccessToken));    
    });

    test('should not set the commImgs on the remoteDataSource with the accessToken and visitId when there is not connectivity', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => false);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      await repository.setCommentedImages(tCommentedImages);
      verify(networkInfo.isConnected());   
      verifyNever(userLocalDataSource.getAccessToken());
      verifyNever(projectsLocalDataSource.getChosenProject());
      verifyNever(visitsLocalDataSource.getChosenVisit(tChosenProject.id));
      verifyNever(remoteDataSource.setCommentedImages(tCommentedImages, tChosenVisit.id, tAccessToken));    
    });

    test('should return Right(null) when there is connectivity and all goes good', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      final result = await repository.setCommentedImages(tCommentedImages);
      expect(result, Right(null));
    });

    test('should return Left(ServerFailure) when there is connectivity and remoteDataSource throws a ServerException', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      when(remoteDataSource.setCommentedImages(any, any, any)).thenThrow(ServerException(type: ServerExceptionType.NORMAL));
      final result = await repository.setCommentedImages(tCommentedImages);
      expect(result, Left(ServerFailure(servExcType: ServerExceptionType.NORMAL)));
    });
  });

  group('getCommentedImages', (){
    String tAccessToken;
    List<SentCommentedImage> tCommentedImages;
    setUp((){
      tAccessToken = 'a_t';
      tCommentedImages = _getSentCommentedImagesFromFixture();
    });

    /*
    test('should set the commImgs on the remoteDataSource with the accessToken and visitId when there is connectivity', ()async{
      when(networkInfo.isConnected()).thenAnswer((_) async => true);
      when(userLocalDataSource.getAccessToken()).thenAnswer((_) async => tAccessToken);
      when(projectsLocalDataSource.getChosenProject()).thenAnswer((_) async => tChosenProject);
      when(visitsLocalDataSource.getChosenVisit(any)).thenAnswer((_) async => tChosenVisit);
      when(remoteDataSource.getCommentedImages(any, any)).thenAnswer((realInvocation) => tCommentedImages)
      await repository.getCommentedImages();
      verify(networkInfo.isConnected());      
      verify(userLocalDataSource.getAccessToken());
      verify(projectsLocalDataSource.getChosenProject());
      verify(visitsLocalDataSource.getChosenVisit(tChosenProject.id));
      verify(remoteDataSource.setCommentedImages(tCommentedImages, tChosenVisit.id, tAccessToken));    
    });
    */
  });
}

List<UnSentCommentedImageModel> _getUnsentCommentedImagesFromFixture(){
  String stringCommImgs = callFixture('unsent_commented_images.json');
  List<Map<String, dynamic>> jsonCommImgs = jsonDecode(stringCommImgs).cast<Map<String, dynamic>>();
  List<UnSentCommentedImageModel> commImgs = jsonCommImgs.map((jci)=>UnSentCommentedImageModel(
    image: File(jci['image_url']),
    commentary: jci['commentary']
  )).toList();
  return commImgs;
}

List<SentCommentedImageModel> _getSentCommentedImagesFromFixture(){
  String stringCommImgs = callFixture('sent_commented_images.json');
  List<Map<String, dynamic>> jsonCommImgs = jsonDecode(stringCommImgs).cast<Map<String, dynamic>>();
  List<SentCommentedImageModel> commImgs = jsonCommImgs.map((jci)=>SentCommentedImageModel(
    url: jci['image_url'],
    commentary: jci['commentary']
  )).toList();
  return commImgs;
}