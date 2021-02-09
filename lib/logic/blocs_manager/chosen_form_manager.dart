import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/logic/bloc/widgets/chosen_form/chosen_form_bloc.dart';
import 'package:gap/logic/bloc/widgets/firm_paint/firm_paint_bloc.dart';
import 'package:gap/data/models/entities/entities.dart';
import 'package:gap/logic/helpers/temp_dir.dart';
import 'package:gap/ui/widgets/forms/form_body/center_containers/form_fields/firm_field/firm_paint.dart';

class ChosenFormManagerSingleton{
  static final ChosenFormManagerSingleton _commImgsIndxManagerSingleton = ChosenFormManagerSingleton._internal();
  static final ChosenFormManager chosenFormManager = ChosenFormManager();
  ChosenFormManagerSingleton._internal();

  factory ChosenFormManagerSingleton({
    @required BuildContext appContext
  }){
    _initInitialElements(appContext);
    return _commImgsIndxManagerSingleton;
  }
  
  static void _initInitialElements(BuildContext appContext){
    chosenFormManager..appContext = appContext
    ..chosenFormBloc = BlocProvider.of<ChosenFormBloc>(appContext)
    ..firmPaintBloc = BlocProvider.of<FirmPaintBloc>(appContext);
  }

  @protected
  factory ChosenFormManagerSingleton.forTesting({
    @required BuildContext appContext,
    @required ChosenFormBloc commImgsBloc,
    @required FirmPaintBloc firmPaintBloc
  }){
    _initInitialTestingElements(appContext, commImgsBloc, firmPaintBloc);
    return _commImgsIndxManagerSingleton;
  }

  static void _initInitialTestingElements(BuildContext appContext, ChosenFormBloc chosenFormBloc, FirmPaintBloc firmPaintBloc){
    chosenFormManager
    ..appContext = appContext
    ..chosenFormBloc = chosenFormBloc
    ..firmPaintBloc = firmPaintBloc;
  }
}


class ChosenFormManager{
  BuildContext appContext;
  ChosenFormBloc chosenFormBloc;
  ChosenFormState chosenFormState;
  FirmPaintBloc firmPaintBloc;

  bool canGoToNextFormStep(){
    _updateState();
    switch(chosenFormState.formStep){
      case FormStep.WithoutForm:
        return true;
      case FormStep.OnForm:
        // TODO: Implementar recorrido de formularios cuando se hayan implementado estos.
        return true;
      case FormStep.OnFirstFirmerInformation:
        return _sePuedeAvanzarDesdeFirstFirmerInfo();
      case FormStep.OnFirstFirmerFirm:
        return _sePuedeAvanzarDesdeFirstFirmerFirm();
      case FormStep.OnSecondaryFirms:
        return _sePuedeAvanzarDesdeSecondaryFirmer();
      default:
        return true;
    }
  }

  bool _sePuedeAvanzarDesdeFirstFirmerInfo(){
    final PersonalInformation firstFirmer = chosenFormState.firmers[0];
    final bool sePuedeAvanzar = _firmerHasPersInfoValues(firstFirmer);
    return sePuedeAvanzar;
  }

  bool _sePuedeAvanzarDesdeFirstFirmerFirm(){
    bool sePuedeAvanzar = _currentFirmerHasEnoughPointsInHisDraw();
    return sePuedeAvanzar;
  }
  
  bool _sePuedeAvanzarDesdeSecondaryFirmer(){
    final List<PersonalInformation> firmers = chosenFormState.firmers;
    final PersonalInformation currentFirmer = firmers.last;
    if( _firmerHasPersInfoValues(currentFirmer) && _currentFirmerHasEnoughPointsInHisDraw())
      return true;
    return false;
  }

  bool _currentFirmerHasEnoughPointsInHisDraw(){
    final FirmPaintState fpState = firmPaintBloc.state;
    final int nTotalPoints = fpState.nTotalPoints;
    return nTotalPoints > 75;
  }

  bool _firmerHasPersInfoValues(PersonalInformation firmer){
    final String name = firmer.name;
    final String identifDocType = firmer.identifDocumentType;
    final int identifDocNumber = firmer.identifDocumentNumber;
    final List invalidValues = [null, ''];
    if(!invalidValues.contains(name) && !invalidValues.contains(identifDocType) && !invalidValues.contains(identifDocNumber)){
      return true;
    }
    return false;
  }

  void addNewFirm(){
    chosenFormBloc.add(InitFirmsFillingOut());
    firmPaintBloc.add(ResetFirmPaint());
    //TODO: ¿Servicio de crear firma en el back se implementa acá?
  }

  void finishFirms(){
    chosenFormBloc.add(ResetChosenForm());
    firmPaintBloc.add(ResetFirmPaint());
    //TODO: ¿Servicio de crear firma en el back se implementa acá?
  }

  Future<void> addFirmToFirmer()async{
    _updateState();
    final int lastFirmerIndex = chosenFormState.firmers.length - 1;
    final FirmPainter firmPainter = firmPaintBloc.state.firmPainter;
    final File firmFile = await _PainterToImageConverter.createFileFromFirmPainter(firmPainter, lastFirmerIndex);
    final PersonalInformation currentFirmer = chosenFormState.firmers[lastFirmerIndex];
    currentFirmer.firm = firmFile;
    final UpdateFirmerPersonalInformation ufpiEvent = UpdateFirmerPersonalInformation(firmer: currentFirmer);
    chosenFormBloc.add(ufpiEvent);
    //TODO: ¿Se llamará al service a add firm to form en lugar de solo guardarla en el bloc?
  }

  void _updateState(){
    chosenFormState = chosenFormBloc.state;
  }
}

class _PainterToImageConverter{

  static final Size _imgsSize = Size(350, 350);

  static Future<File> createFileFromFirmPainter(FirmPainter painter, int firmIndex)async{
    final ByteData byteData = await _convertPainterToByteData(painter);
    final ByteBuffer dataBuffer = byteData.buffer;
    final String tempPath = await TempDir.getFilePath('/firm$firmIndex.png');
    return File(tempPath).writeAsBytes(
      dataBuffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)
    );
  }

  static Future<ByteData> _convertPainterToByteData(FirmPainter painter)async{
    final recorder = new PictureRecorder();
    _paintPainter(painter, recorder);
    final Picture picture = recorder.endRecording();
    final image = await picture.toImage(_imgsSize.width.toInt(), _imgsSize.height.toInt());
    final ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData;
  }

  static void _paintPainter(FirmPainter painter, PictureRecorder recorder){
    final canvas = new Canvas(recorder);
    painter.paint(canvas, _imgsSize);
  }
}