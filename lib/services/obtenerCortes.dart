import 'dart:convert';

import 'package:carniceria/componentes/variables.dart';
import 'package:carniceria/services/models/Cortes.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:fluent_ui/fluent_ui.dart';


//TOOD: Mapping respuesta HTTP from json PHP.

Future<List<Cortes>> fetchCortes(http.Client client) async {
  print(urls[0]);
  final respuesta = await client.get(Uri.parse(urls[0]));
  print("BODY HTTP:"+respuesta.body);
  return compute(parseList, respuesta.body);
}

List<Cortes> parseList(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Cortes>((json) => Cortes.fromJson(json)).toList();
}
