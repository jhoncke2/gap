import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/entities/formularios/formularios_bloc.dart';
import 'package:gap/logic/bloc/entities/visits/visits_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/form_inputs_navigation/form_inputs_navigation_bloc.dart';
import 'package:gap/logic/models/entities/formulario.dart';
import 'package:gap/logic/models/entities/visit.dart';
import 'package:gap/logic/models/entities/EntityWithStages.dart';
import 'package:gap/ui/pages/formulario_detail_page.dart';
import 'package:gap/ui/widgets/header/header.dart';
import 'package:gap/ui/widgets/navigation_list/navigation_list_with_stage_color_buttons.dart';
import 'package:gap/ui/widgets/page_title.dart';
import 'package:gap/ui/widgets/unloaded_elements/unloaded_nav_items.dart';
import 'package:gap/ui/utils/size_utils.dart';
// ignore: must_be_immutable
class FormulariosPage extends StatelessWidget {
  static final String route = 'formularios';
  final SizeUtils _sizeUtils = SizeUtils();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height:_sizeUtils.normalSizedBoxHeigh),
            Header(),
            SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
            _createFormulariosComponent()
          ],
        ),
      ),
    );
  }

  Widget _createFormulariosComponent(){
    return BlocBuilder<FormulariosBloc, FormulariosState>(
      builder: (_, state) {
        if(state.formsAreLoaded){
          return _FormulariosComponents(visitForms: state.forms);
        }else{
          return UnloadedNavItems();
        }
      },
    );
  }
}



// ignore: must_be_immutable
class _FormulariosComponents extends StatelessWidget {
  final SizeUtils _sizeUtils = SizeUtils();
  final List<Formulario> visitForms;
  Visit visit;
  BuildContext _context;
  _FormulariosComponents({
    @required this.visitForms
  });

  @override
  Widget build(BuildContext context) {
    _initInitialConfiguration(context);
    return Container(
      height: _sizeUtils.xasisSobreYasis * 0.75,
      padding: EdgeInsets.only(left: _sizeUtils.xasisSobreYasis * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageTitle(title: this.visit.name, underlined: false),
          SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
          _createDate(),
          SizedBox(height: _sizeUtils.normalSizedBoxHeigh),
          NavigationListWithStageButtons(itemsFunction: _onItemTap, entitiesWithStages: visitForms),
        ],
      )
    );
  }

  void _initInitialConfiguration(BuildContext appContext){
    _context = appContext;
    final VisitsBloc vBloc = BlocProvider.of<VisitsBloc>(appContext);
    this.visit = vBloc.state.chosenVisit;
  }

  Widget _createDate(){
    return Container(   
      padding: EdgeInsets.only(left: _sizeUtils.xasisSobreYasis * 0.03),
      child: Text(
        visit.date.toString().split(' ')[0],
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: _sizeUtils.subtitleSize,
          color: Theme.of(_context).primaryColor
        ),
      ),
    );
  }

  void _onItemTap(EntityWithStages entity){
    _addChosenFormToForms(entity);
    //TODO: Revisar que esté haciendo algo que tenga sentido
    _addEntityToFormInputsNav(entity);
    _addFormToChosenFormBloc(entity);
    Navigator.of(_context).pushNamed(FormularioDetailPage.route);
  }

  void _addChosenFormToForms(Formulario form){
    final FormulariosBloc formsBloc = BlocProvider.of<FormulariosBloc>(_context);
    final ChooseForm chooseFormEvent = ChooseForm(chosenOne: form);
    formsBloc.add(chooseFormEvent);
  }

  void _addEntityToFormInputsNav(Formulario form){
    final FormInputsNavigationBloc fINavBloc = BlocProvider.of<FormInputsNavigationBloc>(_context);
    final SetForm setFormEvent = SetForm(form: form);
    fINavBloc.add(setFormEvent);
  }

  void _addFormToChosenFormBloc(Formulario form){
    final ChosenFormBloc cFBloc = BlocProvider.of<ChosenFormBloc>(_context);
    final InitFormFillingOut initFormFOEvent = InitFormFillingOut(formulario: form);
    cFBloc.add(initFormFOEvent);
  }
}