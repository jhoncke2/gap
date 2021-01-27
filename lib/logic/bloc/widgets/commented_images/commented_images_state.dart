part of 'commented_images_bloc.dart';

@immutable
class CommentedImagesState {
  final int nPaginasDeCommImages;
  final int nWidgetsPerPage;
  final List<List<CommentedImage>> _commentedImagesPerPage;

  CommentedImagesState({
    this.nPaginasDeCommImages = 0, 
    this.nWidgetsPerPage, 
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
    nWidgetsPerPage:nWidgetsPerPage??this.nWidgetsPerPage,
    commentedImagesPerPage:commentedImagesPerPage??this._commentedImagesPerPage
  );
  
  List<CommentedImage>  getWidgetsByIndex(int index){
    return _commentedImagesPerPage[index];
  }
}