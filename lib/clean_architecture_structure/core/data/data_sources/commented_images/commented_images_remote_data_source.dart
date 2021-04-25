import 'dart:convert';
import 'dart:io';

import 'package:gap/clean_architecture_structure/core/error/exceptions.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:gap/clean_architecture_structure/core/data/data_sources/central/remote_data_source.dart';
import 'package:gap/clean_architecture_structure/core/data/models/commented_image_model.dart';

abstract class CommentedImagesRemoteDataSource{
  Future<void> setCommentedImages(List<UnSentCommentedImageModel> commImgs, int visitId, String accessToken);
  Future<List<SentCommentedImageModel>> getCommentedImages(int visitId, String accessToken);
}

class CommentedImagesRemoteDataSourceImpl extends RemoteDataSourceWithMultiPartRequests implements CommentedImagesRemoteDataSource{
  static const COMM_IMGS_URL = 'panel/visita-fotos';
  final http.Client client;

  CommentedImagesRemoteDataSourceImpl({
    @required this.client
  });

  @override
  Future<void> setCommentedImages(List<UnSentCommentedImageModel> commImgs, int visitId, String accessToken)async{
    try{
      final String requestUrl = super.BASE_URL + '/$COMM_IMGS_URL/$visitId';
      final Map<String, String> headers = {'Authorization':'Bearer $accessToken'};
      List<String> commentaries = [];
      List<File> images = [];
      commImgs.forEach((commImg) {
        commentaries.add(commImg.commentary);
        images.add(commImg.image);
      });
      final Map<String, String> fields = {'descriptions': jsonEncode(commentaries)};
      final Map<String, dynamic> filesInfo = {'files_field':'photos[]', 'files':images};
      final http.Response response = await executeMultiPartRequestWithListOfFiles(requestUrl, headers, fields, filesInfo);
      if(response.statusCode != 200)
        throw Exception();
    }catch(exception){
      throw ServerException();
    }
  }

  @override
  Future<List<SentCommentedImageModel>> getCommentedImages(int visitId, String accessToken)async{
    try{
      final String unencodedPath = '/$COMM_IMGS_URL/$visitId';
      final Map<String, String> headers = {'Authorization': 'Bearer $accessToken'};
      final response = await client.get(
        Uri.http(super.BASE_URL, unencodedPath), 
        headers: headers
      );
      if(response.statusCode != 200)
        throw Exception();
      final List<Map<String, dynamic>> jsonResponseBody = jsonDecode(response.body).cast<Map<String, dynamic>>();
      return commentedImagesFromJson(jsonResponseBody);
    }catch(exception){
      throw ServerException();
    }
  }
}