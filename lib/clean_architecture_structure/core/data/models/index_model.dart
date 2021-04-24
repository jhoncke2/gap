import 'package:meta/meta.dart';
import 'package:gap/clean_architecture_structure/core/domain/entities/index.dart';

class IndexModel extends Index{
  IndexModel({
    @required int pages,
    @required int currentPage,
    @required bool canAdvance,
    @required bool canBack
  }):super(
    pages: pages,
    currentPage: currentPage,
    canAdvance: canAdvance,
    canBack: canBack,    
  );

  factory IndexModel.fromJson(Map<String, dynamic> json)=>IndexModel(
    pages: json['pages'],
    currentPage: json['current_page'],
    canAdvance: json['can_advance'],
    canBack: json['can_back']
  );

  Map<String, dynamic> toJson() => {
    'pages': pages,
    'current_page': currentPage,
    'can_advance': canAdvance,
    'can_back': canBack,
  };
}