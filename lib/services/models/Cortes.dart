
import 'dart:convert';

class Cortes {

  final String? idCorte;
  final String? nombreCorte;
  final String? descripcionCorte;
  final String? imgCorte;
  final String? precioCorte;

  Cortes({this.idCorte, this.nombreCorte, this.descripcionCorte, this.imgCorte,this.precioCorte});

  factory Cortes.fromJson(Map<String, dynamic> json){
    return Cortes(
      idCorte: json['idCorte'],
      nombreCorte: json['nombreCorte'],
      descripcionCorte: json['descripcionCorte'],
      imgCorte: json['imgCorte'],
      precioCorte: json['precioCorte']
    );
  }


}