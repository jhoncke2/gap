import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/blocs/user/user_bloc.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/general_button.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/logo.dart';
import 'package:gap/clean_architecture_structure/core/presentation/widgets/scaffold_keyboard_detector.dart';
import 'package:gap/clean_architecture_structure/features/login/presentation/widgets/login_bottom.dart';
import 'package:gap/clean_architecture_structure/features/login/presentation/widgets/login_button.dart';
import 'package:gap/old_architecture/ui/utils/size_utils.dart';
import 'package:gap/clean_architecture_structure/injection_container.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SizeUtils _sizeUtils = SizeUtils();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _sizeUtils.initUtil(MediaQuery.of(context).size);
    return ScaffoldKeyboardDetector(
      child: SafeArea(
        child: SingleChildScrollView(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<UserBloc>(create: (_)=>sl()),
              BlocProvider<NavigationBloc>(create: (_)=>sl())
            ],
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: _sizeUtils.largeHorizontalScaffoldPadding
              ),
              child: _crearComponentes(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearComponentes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: _sizeUtils.giantSizedBoxHeight),
        Logo(heightPercent: 0.1, widthPercent: 0.28),
        SizedBox(height: _sizeUtils.giantSizedBoxHeight),
        _crearFormInput(_crearEmailInput(), 'Usuario'),
        SizedBox(height: _sizeUtils.largeSizedBoxHeigh),
        _crearFormInput(_crearPasswordInput(), 'Contraseña'),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        //_crearBotonLogin(),
        LoginButton(emailController: _emailController, passwordController: _passwordController),
        SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
        LoginBottom()
      ],
    );
  }

  Widget _crearFormInput(Widget textFormField, String titulo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _crearFormInputTitle(titulo),
        SizedBox(height: _sizeUtils.littleSizedBoxHeigh * 0.5),
        textFormField
      ],
    );
  }

  Widget _crearFormInputTitle(String titulo) {
    return Container(
      padding: EdgeInsets.only(left: _sizeUtils.xasisSobreYasis * 0.00),
      child: Text(
        titulo,
        style: TextStyle(
          fontSize: _sizeUtils.normalTextSize,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _crearEmailInput() {
    return _createGeneralInput(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      obscureText: false,
      icon: Icons.person_outline
    );
  }

  Widget _crearPasswordInput() {
    return _createGeneralInput(
      controller: _passwordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      icon: Icons.lock_outline
    );
  }

  Widget _createGeneralInput({TextEditingController controller, TextInputType keyboardType, bool obscureText, IconData icon}){
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        isCollapsed: true,
        prefixIcon: Icon(
          icon,
          size: _sizeUtils.normalIconSize,
        ),
        border: _crearInputBorder(),
        enabledBorder: _crearInputBorder()
      ),
    );
  }

  InputBorder _crearInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.065),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor.withOpacity(0.525),
        width: 3.5
      )
    );
  }
}