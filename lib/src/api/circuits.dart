import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:formula1_data/src/converters/circuits/circuit.dart';

Future<List<Circuit>> getCircuit({int? year}) async {
  year = year ?? DateTime.now().year;
  List<Circuit> circuits = [];
  try {
    Dio dio = Dio();
    final Response response =
        await dio.get("https://api.jolpi.ca/ergast/f1/$year/circuits.json");
    final dynamic data = response.data;
    final List<dynamic> circuitsData =
        data["MRData"]["CircuitTable"]["Circuits"];
    for (var data in circuitsData) {
      final Circuit circuit = Circuit.fromMap(data);
      circuits.add(circuit);
    }
  } on DioException catch (error) {
    debugPrint(error.message.toString());
  }
  return circuits;
}
