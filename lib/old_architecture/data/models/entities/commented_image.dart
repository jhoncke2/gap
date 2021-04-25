part of 'entities.dart';

List<CommentedImageOld> commentedImagesFromJson(List<Map<String, dynamic>> jsonCommImgs)=>jsonCommImgs.map<CommentedImageOld>((json)=>SentCommentedImageOld.fromJson(json)).toList();
List<Map<String, dynamic>> commentedImagesToJson(List<CommentedImageOld> cmmImgs)=>cmmImgs.map((cmmImg) => cmmImg.toJson()).toList();

abstract class CommentedImageOld{
  String commentary;
  int positionInPage;
  String imgnUrl;

  CommentedImageOld({
    @required this.commentary,
    @required this.imgnUrl,
    this.positionInPage,
  });

  Map<String, dynamic> toJson() =>{};
}

class UnSentCommentedImageOld extends CommentedImageOld{

  File image;

  UnSentCommentedImageOld({
    @required this.image,  
    String commentary = '',
    int positionInPage,
  }):super(
    commentary: commentary,
    imgnUrl: image.path,
    positionInPage: positionInPage
  );
  
  factory UnSentCommentedImageOld.fromJson(Map<String, dynamic> json)=>UnSentCommentedImageOld(
    image: File(json['image_url']),
    commentary: json['commentary'],
    positionInPage: json['position_in_page']
  );

  @override
  Map<String, dynamic> toJson() => {
    'image_url': this.image.path,
    'commentary': this.commentary,
    'position_in_page': this.positionInPage
  };
}

class SentCommentedImageOld extends CommentedImageOld{
  static final String baseUrl = 'https://gapfergon.com/';
  String url;

  SentCommentedImageOld({
    @required String url,
    String commentary = ''
  }):
  this.url = baseUrl + url,
  super(
    commentary: commentary,
    imgnUrl: baseUrl + url
  );
  
  factory SentCommentedImageOld.fromJson(Map<String, dynamic> json)=>SentCommentedImageOld(
    url: json['ruta'],
    commentary: json['descripcion'],
  );
}