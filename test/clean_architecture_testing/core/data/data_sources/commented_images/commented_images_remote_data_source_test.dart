import 'dart:convert';
import 'package:gap/clean_architecture_structure/core/data/data_sources/central/remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:gap/clean_architecture_structure/core/data/models/commented_image_model.dart';
import 'package:gap/clean_architecture_structure/core/platform/storage_connector.dart';
import 'package:gap/clean_architecture_structure/core/data/data_sources/commented_images/commented_images_remote_data_source.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockStorageConnector extends Mock implements StorageConnector{}
class MockHttpClient extends Mock implements http.Client{}

CommentedImagesRemoteDataSourceImpl remoteDataSource;
MockHttpClient client;

void main(){
  setUp((){
    client = MockHttpClient();
    remoteDataSource = CommentedImagesRemoteDataSourceImpl(
      client: client,
    );
  });

  group('setCommentedImages', (){
    //TODO: Implementar una forma de testear completamente. Aún no lo he podido lograr.
  });

  group('getCommentedImages', (){
    String tApiUrl;
    String tAccessToken;
    int tVisitId;
    String tStringCommImgs;
    List<Map<String, dynamic>> tJsonCommImgs;
    List<SentCommentedImageModel> tCommImgs;
    Map<String, String> tHeaders;

    setUp((){
      tApiUrl = remoteDataSource.BASE_URL + CommentedImagesRemoteDataSourceImpl.COMM_IMGS_URL + '$tVisitId';
      tAccessToken = 'access_token';
      tVisitId = 1;
      tStringCommImgs = callFixture('sent_commented_images.json');
      tJsonCommImgs = jsonDecode(tStringCommImgs).cast<Map<String, dynamic>>();
      tCommImgs = tJsonCommImgs.map((ci) => SentCommentedImageModel.fromJson(ci)).toList();
      tHeaders = {'Authorization':'Bearer $tAccessToken'};
    });

    test('should get the commentedImages from the http client, with the tHeaders, using the apiUrl', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringCommImgs, 200));
      await remoteDataSource.getCommentedImages(tVisitId, tAccessToken);
      verify(client.get(
        Uri.http(remoteDataSource.BASE_URL, '/${CommentedImagesRemoteDataSourceImpl.COMM_IMGS_URL}/$tVisitId'), 
        headers: tHeaders
      ));
    });

    test('should return the tCommImgs when all goes good', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringCommImgs, 200));
      final List<SentCommentedImageModel> commImgs = await remoteDataSource.getCommentedImages(tVisitId, tAccessToken);
      expect(commImgs, tCommImgs);
    });

    test('should throw a ServerException when the response code is not 200', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tStringCommImgs, 500));
      final call = remoteDataSource.getCommentedImages;
      expect(()=> call(tVisitId, tAccessToken), throwsA(TypeMatcher<ServerException>()));
    });

    test('should throw a ServerException when the body is not a json', ()async{
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('Internal server error con status code 200, porque me gusta ser troll', 200));
      final call = remoteDataSource.getCommentedImages;
      expect(()=> call(tVisitId, tAccessToken), throwsA(TypeMatcher<ServerException>()));
    });
  });
}