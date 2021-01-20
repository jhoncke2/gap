import 'package:flutter/material.dart';
import 'package:gap/widgets/page_title.dart';
class Form extends StatelessWidget {
  const Form({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          PageTitle(title: '')
        ],
      )
    );
  }
}