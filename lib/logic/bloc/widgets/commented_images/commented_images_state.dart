part of 'commented_images_bloc.dart';

@immutable
class CommentedImagesState {
  final int nPaginasDeCommImages;
  final int commImgsPerPage;
  final List<List<CommentedImage>> _commentedImagesPerPage;

  CommentedImagesState({
    this.nPaginasDeCommImages = 0, 
    this.commImgsPerPage, 
    List<List<CommentedImage>> commentedImagesPerPage
  }):
    _commentedImagesPerPage = commentedImagesPerPage??[]
    ;

  CommentedImagesState copyWith({
    int nPaginasDeWidgets,
    int nWidgetsPerPage,
    List<List<CommentedImage>> commentedImagesPerPage
  }) => CommentedImagesState(
    nPaginasDeCommImages:nPaginasDeWidgets??this.nPaginasDeCommImages,
    commImgsPerPage:nWidgetsPerPage??this.commImgsPerPage,
    commentedImagesPerPage:commentedImagesPerPage??this._commentedImagesPerPage,
  );
  
  List<CommentedImage>  getCommImgsByIndex(int index){
    return _commentedImagesPerPage[index];
  }

  List<CommentedImage> get allCommentedImages{
    final List<CommentedImage> commImgs = [];
    _commentedImagesPerPage.forEach((currentCommImgs) {
      commImgs.addAll(currentCommImgs);
    });
    return commImgs;
  }
}