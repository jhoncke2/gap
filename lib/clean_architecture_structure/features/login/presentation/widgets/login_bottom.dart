import 'package:flutter/material.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class LoginBottom extends StatefulWidget {
  bool mantenermeEnElSistema;
  LoginBottom({Key key}) : super(key: key){
    mantenermeEnElSistema = false;
  }

  @override
  _LoginBottomState createState() => _LoginBottomState();
}

class _LoginBottomState extends State<LoginBottom> {
  final SizeUtils _sizeUtils = SizeUtils();

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _createForgottenPasswordButton(),
        _createMantenerEnElSistemaItems()
      ],
    );
  }

  Widget _createForgottenPasswordButton() {
    return FlatButton(
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.symmetric(
          horizontal: _sizeUtils.xasisSobreYasis * 0.025, vertical: 0),
      shape: StadiumBorder(),
      child: _createLabel('¿Olvidaste tu contraseña?'),
      onPressed: () {},
    );
  }

  Widget _createMantenerEnElSistemaItems() {
    return Container(
      margin: EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Checkbox(
              visualDensity: VisualDensity.compact,
              value: widget.mantenermeEnElSistema,
              onChanged: (bool newValue) {
                setState(() {
                  widget.mantenermeEnElSistema = newValue;
                });
              }),
          ),
          _createLabel('Mantenerme en el sistema'),
          SizedBox(width: _sizeUtils.xasisSobreYasis * 0.035)
        ],
      ),
    );
  }

  Widget _createLabel(String text) {
    DateTime nowTime = DateTime.now();
    nowTime = nowTime.add(Duration(hours: 3));
    final String nowToString = nowTime.toString();
    print(nowToString);
    return Text(
      text,
      style: TextStyle(
        fontSize: _sizeUtils.normalTextSize,
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w500
      ),
    );
  }
}