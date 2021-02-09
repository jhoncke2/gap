part of 'entities.dart';

class CommentedImage{
  File image;
  int positionInPage;
  String commentary;
  CommentedImage({
    @required this.image,  
    this.positionInPage, 
    this.commentary = ''
  });

  CommentedImage.fromJson(Map<String, dynamic> json){
    image = File(json['image_path']);
    positionInPage = json['position_in_page'];
    commentary = json['commentary'];
  }

  Map<String, dynamic> toJson()=> {
    'image_path': image.path,
    'position_in_page':positionInPage,
    'commentary':commentary
  };

  
}