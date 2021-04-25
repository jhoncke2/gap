import '../custom_form_field.dart';

abstract class StaticFormField extends CustomFormField{
  final FormFieldSubType subType;
  StaticFormField({
    this.subType,
    FormFieldType type,
    String label,
    bool other
  }):super(
    type: type,    
    label: label,
    other: other
  );

  @override
  List<Object> get props => super.props..add(subType.value);
}

class HeaderFormField extends StaticFormField{

}

class ParagraphFormField extends StaticFormField{

}

class HeaderSubType extends FormFieldSubType{
  static final List<HeaderSubType> subtypes = [H1, H2, H3, H4, H5, H6];
  const HeaderSubType(String value) : super(value);

  static const HeaderSubType H1 = HeaderSubType('h1');  
  static const HeaderSubType H2 = HeaderSubType('h2');
  static const HeaderSubType H3 = HeaderSubType('h3');
  static const HeaderSubType H4 = HeaderSubType('h4');
  static const HeaderSubType H5 = HeaderSubType('h5');
  static const HeaderSubType H6 = HeaderSubType('h6');

  factory HeaderSubType.fromValue(String value){
    return FormFieldSubType.getSubTypeFromValue(value, subtypes);
  }
}

class ParagraphSubtype extends FormFieldSubType{
  static final List<ParagraphSubtype> subtypes = [P, ADDRESS, BLOCKQUOTE, CANVAS, OUTPUT];

  const ParagraphSubtype(String value) : super(value);

  static const ParagraphSubtype P = ParagraphSubtype('p');
  static const ParagraphSubtype ADDRESS = ParagraphSubtype('address');
  static const ParagraphSubtype BLOCKQUOTE = ParagraphSubtype('blockquote');
  static const ParagraphSubtype CANVAS = ParagraphSubtype('canvas');
  static const ParagraphSubtype OUTPUT = ParagraphSubtype('output');

  factory ParagraphSubtype.fromValue(String value){
    return FormFieldSubType.getSubTypeFromValue(value, subtypes);
  }
}