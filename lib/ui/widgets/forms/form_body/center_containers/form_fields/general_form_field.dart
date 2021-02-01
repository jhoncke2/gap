import 'package:flutter/material.dart';
import 'package:gap/ui/utils/size_utils.dart';
// ignore: must_be_immutable
abstract class GeneralFormField extends StatelessWidget {
  final SizeUtils sizeUtils = SizeUtils();
  final Function onFieldChanged;
  final double width;
  BuildContext context;
  @protected
  Widget fieldHead;
  @protected
  Widget fieldBox;

  GeneralFormField({
    Key key,
    @required this.onFieldChanged,
    this.width = double.infinity
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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