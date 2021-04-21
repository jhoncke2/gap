import 'package:flutter/material.dart';
class CustomProgressIndicator extends StatelessWidget {
  final double heightScreenPercentage;
  const CustomProgressIndicator({Key key, this.heightScreenPercentage = 0.9}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * this.heightScreenPercentage,
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.cyan[600],
          strokeWidth: 7.5,
        ),
      ),
    );
  }
}