import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class Rango extends Equatable{
  final int id;
  final String nombre;
  final List<double> pesosEsperados;
  final bool completo;

  Rango({
    @required this.id, 
    @required this.nombre, 
    @required this.pesosEsperados, 
    @required this.completo
  });

  @override
  List<Object> get props => [
    this.id,
    this.nombre,
    this.pesosEsperados,
    this.completo    
  ];
  
  // ignore: missing_return
  Rango copyWith({
    int id,
    String nombre,
    List<double> pesosEsperados,
    bool completo
  }){}
}