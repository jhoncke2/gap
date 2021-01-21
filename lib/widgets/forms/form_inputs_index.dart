import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/bloc/ui/form_inputs_navigation/form_inputs_navigation_bloc.dart';
import 'package:gap/utils/size_utils.dart';
import 'package:gap/widgets/unloaded_elements/unloaded_form_inputs_index.dart';
class FormInputsIndex extends StatelessWidget {
  const FormInputsIndex();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormInputsNavigationBloc, FormInputsNavigationState>(
      builder: (context, state) {
        if(state.thereIsSelectedForm){
          return _LoadedFormInputsIndex(state: state);
        }else{
          return UnloadedFormInputsIndex();
        }
      },
    );
  }
}


// ignore: must_be_immutable
class _LoadedFormInputsIndex extends StatelessWidget {
  final FormInputsNavigationState state;
  final SizeUtils _sizeUtils = SizeUtils();
  BuildContext _context;
  _LoadedFormInputsIndex({
    @required this.state
  });

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.0375,
      width: _sizeUtils.xasisSobreYasis * 0.4875,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _createIndexButton('Anterior'),
          _createIndexButton('1'),
          _createIndexButton('2'),
          _createIndexButton('3'),
          _createSingleText('...'),
          _createIndexButton('8'),
          _createIndexButton('Siguiente')
        ],
      ),
    );
  }

  Widget _createIndexButton(String buttonName){
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.zero,
        child: _createSingleText(buttonName),
        decoration: _createButtonDecoration(),

      ),
      onTap: (){

      },
    );
  }

  BoxDecoration _createButtonDecoration(){
    return BoxDecoration(
      borderRadius: BorderRadius.circular(_sizeUtils.xasisSobreYasis * 0.045)
    );
  }

  Widget _createSingleText(String text){
    return Text(
      text,
      style: TextStyle(
        fontSize: _sizeUtils.subtitleSize,
        color: Theme.of(_context).primaryColor.withOpacity(0.85)
      ),
    );
  }
}