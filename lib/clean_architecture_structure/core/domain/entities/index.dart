import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class Index extends Equatable{
  final int pages;
  final int currentPage;
  final bool canAdvance;
  final bool canBack;

  Index({
    @required this.pages, 
    @required this.currentPage, 
    @required this.canAdvance, 
    @required this.canBack
  });

  @override
  List<Object> get props => [pages, currentPage, canAdvance, canBack];
}