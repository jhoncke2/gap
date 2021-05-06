import 'package:flutter/material.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_button.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';

// ignore: must_be_immutable
abstract class GeneralFormField extends StatelessWidget {
  final SizeUtils sizeUtils = SizeUtils();
  final Function onFieldChanged;
  final double width;
  final BtnBorderShape borderShape;
  final ValueNotifier controller;
  BuildContext context;
  @protected
  Widget fieldHead;
  @protected
  Widget fieldBox;

  GeneralFormField({
    Key key,
    @required this.onFieldChanged,
    this.borderShape = BtnBorderShape.Circular,
    this.width = double.infinity,
    this.controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fieldHead,
          SizedBox(height:  sizeUtils.veryLittleSizedBoxHeigh),
          fieldBox
        ],
      ),
    );
  }

  
}