part of 'entities.dart';

class PersonalInformations{
  List<PersonalInformationOld> personalInformations = [];
  PersonalInformations.fromJson(List<Map<String, dynamic>> json){
    if(json == null)
      return;
    personalInformations = json.map(
      (Map<String, dynamic> item)=>PersonalInformationOld.fromJson(item)
    ).toList();
  }

  static List<Map<String, dynamic>> toJson(List<PersonalInformationOld> persInfs){
    final List<Map<String, dynamic>> persInfsAsMap = persInfs.map(
      (PersonalInformationOld pI) => pI.toJson()
    ).toList();
    return persInfsAsMap;
  }
}

class  PersonalInformationOld{
  int id;
  String name;
  String identifDocumentType;
  int identifDocumentNumber;
  File firm;

  PersonalInformationOld({
    this.id, 
    this.name,
    this.identifDocumentType,
    this.identifDocumentNumber, 
    this.firm
  });

  PersonalInformationOld.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    identifDocumentType = json['identif_document_type'];
    identifDocumentNumber = json['identif_document_number'];
    _convertFirmToFile(json['firm']);
  }

  void _convertFirmToFile(String firmAsString){
    try{
      firm = File(firmAsString);
    }catch(err){
      firm = File('assets/logos/logo_con_fondo.png');
    }
  }
  
  Map<String, dynamic> toJson() => {
    'id':id,    
    'name':name,
    'identif_document_type':identifDocumentType,
    'identif_document_number':identifDocumentNumber,
    //TODO: Convertir a data que se pueda desconvertir más tarde
    'firm':firm.path    
  };

  Map<String, String> toServiceJson() => {
    'tipo_dc':identifDocumentType,
    'cc':identifDocumentNumber.toString(),
    'nombre':name
  };
  
  PersonalInformationOld clone()=> PersonalInformationOld(
    id: this.id,
    name: this.name,
    identifDocumentType: this.identifDocumentType,
    identifDocumentNumber: this.identifDocumentNumber,
    firm: this.firm
  );
}