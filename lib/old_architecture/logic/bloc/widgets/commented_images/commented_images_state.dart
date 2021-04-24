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
  final List<List<CommentedImageOld>> _commentedImagesPerPage;
  final CmmImgDataType dataType;
  final bool isLoading;

  CommentedImagesState({
    this.nPaginasDeCommImages = 0, 
    this.commImgsPerPage,
    List<List<CommentedImageOld>> commentedImagesPerPage,
    this.dataType = CmmImgDataType.NONE,
    this.isLoading = true,
  }):
    _commentedImagesPerPage = commentedImagesPerPage??[]
    ;

  CommentedImagesState copyWith({
    int nPaginasDeWidgets,
    int nWidgetsPerPage,
    List<List<CommentedImageOld>> commentedImagesPerPage,
    CmmImgDataType dataType,
    bool isLoading
  }) => CommentedImagesState(
    nPaginasDeCommImages: nPaginasDeWidgets??this.nPaginasDeCommImages,
    commImgsPerPage: nWidgetsPerPage??this.commImgsPerPage,
    commentedImagesPerPage: commentedImagesPerPage??this._commentedImagesPerPage,
    dataType: dataType??this.dataType,
    isLoading: isLoading??this.isLoading
  );
  
  List<CommentedImageOld>  getCommImgsByIndex(int index){
    return _commentedImagesPerPage[index];
  }

  List<CommentedImageOld> get allCommentedImages{
    final List<CommentedImageOld> commImgs = [];
    _commentedImagesPerPage.forEach((currentCommImgs) {
      commImgs.addAll(currentCommImgs);
    });
    return commImgs;
  }
}