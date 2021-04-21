part of 'entities.dart';

List<CommentedImage> commentedImagesFromJson(List<Map<String, dynamic>> jsonCommImgs)=>jsonCommImgs.map<CommentedImage>((json)=>SentCommentedImage.fromJson(json)).toList();
List<Map<String, dynamic>> commentedImagesToJson(List<CommentedImage> cmmImgs)=>cmmImgs.map((cmmImg) => cmmImg.toJson()).toList();

abstract class CommentedImage{
  String commentary;
  int positionInPage;
  String imgnUrl;

  CommentedImage({
    @required this.commentary,
    @required this.imgnUrl,
    this.positionInPage,
  });

  Map<String, dynamic> toJson() =>{};
}

class UnSentCommentedImage extends CommentedImage{

  File image;

  UnSentCommentedImage({
    @required this.image,  
    String commentary = '',
    int positionInPage,
  }):super(
    commentary: commentary,
    imgnUrl: image.path,
    positionInPage: positionInPage
  );

  factory UnSentCommentedImage.fromJson(Map<String, dynamic> json)=>UnSentCommentedImage(
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

class SentCommentedImage extends CommentedImage{
  static final String baseUrl = 'https://gapfergon.com/';
  String url;

  SentCommentedImage({
    @required String url,
    String commentary = ''
  }):
  this.url = baseUrl + url,
  super(
    commentary: commentary,
    imgnUrl: baseUrl + url
  );
  
  factory SentCommentedImage.fromJson(Map<String, dynamic> json)=>SentCommentedImage(
    url: json['ruta'],
    commentary: json['descripcion'],
  );
}