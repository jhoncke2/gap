import 'package:flutter/material.dart';
import 'package:gap/pages/projects_page.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/logo.dart';

class LoginPage extends StatefulWidget {
  static final String route = 'login';

  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  BuildContext _context;
  SizeUtils _sizeUtils;
  String _email;
  String _password;
  bool _mantenermeEnElSistema = false;

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: _sizeUtils.largeHorizontalScaffoldPadding
            ),
            child: _crearComponentes(),
          ),
        ),
      ),
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    _sizeUtils = SizeUtils();
    _sizeUtils.initUtil(MediaQuery.of(appContext).size);
  }

  Widget _crearComponentes(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: _sizeUtils.giantSizedBoxHeight),
        Logo(heightPercent: 0.1, widthPercent: 0.28), 
        SizedBox(height: _sizeUtils.giantSizedBoxHeight),
        _crearFormInput('user'),
        SizedBox(height: _sizeUtils.largeSizedBoxHeigh),
        _crearFormInput('password'),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        _crearBotonLogin(),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        _createBottomComponents()
      ],
    );
  }
  

  Widget _crearFormInput(String tipo){
    final Widget input = _generarInputSegunTipo(tipo);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _crearFormInputTitle(tipo),
        SizedBox(height: _sizeUtils.littleSizedBoxHeigh * 0.5),
        input
      ],
    );
  }

  Widget _crearFormInputTitle(String tipoInput){
    final String title = _elegirTituloDeInput(tipoInput);
    return Container(
      padding: EdgeInsets.only(left: _sizeUtils.xasisSobreYasis * 0.00),
      child: Text(
        title,
        style: TextStyle(
          fontSize: _sizeUtils.normalTextSize,
          color: Theme.of(_context).primaryColor,
          fontWeight: FontWeight.w500
        ),
      ),
    );
  }

  String _elegirTituloDeInput(String tipoInput){
    if(tipoInput == 'user')
      return "Usuario";
    else
      return 'Contraseña';
  }

  Widget _generarInputSegunTipo(String tipo){
    Widget input;
    if(tipo == 'user'){
      input = _crearEmailInput();
    }else{
      input = _crearPasswordInput();
    }
    return input;
  }

  Widget _crearEmailInput(){
    return TextField(
      keyboardType: TextInputType.emailAddress,
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        isCollapsed: true,
        prefixIcon: Icon(
          Icons.person_outline,
          size: _sizeUtils.normalIconSize,
        ),
        enabledBorder: _crearInputBorder(),
        border: _crearInputBorder(),
      ),
      onChanged: (String newValue){
        _email = newValue;
      }
    );
  }

  Widget _crearPasswordInput(){
    return TextField(
      keyboardType: TextInputType.text,
      obscureText: true,
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        isCollapsed: true,
        prefixIcon: Icon(
          //FontAwesomeIcons.lock
          Icons.lock_outline,
          size: _sizeUtils.normalIconSize,
        ),
        border: _crearInputBorder(),
        enabledBorder: _crearInputBorder()
      ),
      onChanged: (String newValue){
        _password = newValue;
      }
    );
  }

  InputBorder _crearInputBorder(){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.065),
      borderSide: BorderSide(
        color: Theme.of(_context).primaryColor.withOpacity(0.525),
        width: 3.5
      )
    );
  }

  Widget _crearBotonLogin(){
    final Map<String, double> shortFlatButtonPadding = _sizeUtils.shortFlatButtonPadding;
    final double horizontalPadding = shortFlatButtonPadding['horizontal'];
    final double verticalPadding = shortFlatButtonPadding['vertical'];
    return MaterialButton(
      child: _crearTextoDeBoton('INGRESAR'),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      shape: new RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.03)
      ),
      color: Theme.of(_context).primaryColor,
      onPressed: _login,
    );
  }

  Widget _crearTextoDeBoton(String texto){
    return Text(
      texto,
      style: TextStyle(
        color: Colors.white,
        fontSize: _sizeUtils.littleTitleSize
      ),
    );
  }

  void _login(){
    Navigator.of(context).pushReplacementNamed(ProjectsPage.route);
  }

  Widget _createBottomComponents(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _createForgottenPasswordButton(),
        _createMantenerEnElSistemaItems()
      ],
    );
  }

  Widget _createForgottenPasswordButton(){
    return FlatButton(
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.symmetric(horizontal: _sizeUtils.xasisSobreYasis * 0.025, vertical: 0),
      shape: StadiumBorder(),
      child: _createLabel('¿Olvidaste tu contraseña?'),
      onPressed: (){

      },
    );
  }

  Widget _createMantenerEnElSistemaItems(){
    return Container(
      margin: EdgeInsets.all(0),
      child: Row(
        children: [
          Container(
            child: Checkbox(
              visualDensity: VisualDensity.compact,
              value: _mantenermeEnElSistema, 
              onChanged: (bool newValue){
                setState((){
                  _mantenermeEnElSistema = newValue;
                });
              }
            ),
          ),
          _createLabel('Mantenerme en el sistema')
        ],
      ),
    );
  }

  Widget _createLabel(String text){
    return Text(
      text,
      style: TextStyle(
        fontSize: _sizeUtils.normalTextSize,
        color: Theme.of(_context).primaryColor,
        fontWeight: FontWeight.w500
      ),
    );
  }
}