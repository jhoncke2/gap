part of 'commented_images_bloc.dart';

enum CmmImgDataType{
  NONE,
  UNSENT,
  SENT
}

@immutable
class CommentedImagesState {
  final int nPaginasDeCommImages;
  final int commImgsPerPage;
  final List<List<CommentedImage>> _commentedImagesPerPage;
  final CmmImgDataType dataType;
  final bool isLoading;

  CommentedImagesState({
    this.nPaginasDeCommImages = 0, 
    this.commImgsPerPage,
    List<List<CommentedImage>> commentedImagesPerPage,
    this.dataType = CmmImgDataType.NONE,
    this.isLoading = true,
  }):
    _commentedImagesPerPage = commentedImagesPerPage??[]
    ;

  CommentedImagesState copyWith({
    int nPaginasDeWidgets,
    int nWidgetsPerPage,
    List<List<CommentedImage>> commentedImagesPerPage,
    CmmImgDataType dataType,
    bool isLoading
  }) => CommentedImagesState(
    nPaginasDeCommImages: nPaginasDeWidgets??this.nPaginasDeCommImages,
    commImgsPerPage: nWidgetsPerPage??this.commImgsPerPage,
    commentedImagesPerPage: commentedImagesPerPage??this._commentedImagesPerPage,
    dataType: dataType??this.dataType,
    isLoading: isLoading??this.isLoading
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