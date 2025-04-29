import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:formula1_data/formula1_data.dart';
import 'package:formula1_data/src/service/dio_client.dart';

Future<dynamic> getConstructorStanding({int? year}) async {
  year = year ?? DateTime.now().year;
  List<ConstructorStanding> constructorStandings = [];
  try {
    final response =
        await DioClient().dio.get('/$year/constructorstandings.json');

    final dynamic data = response.data;
    final List<dynamic> constructorStandingData =
        data["MRData"]["StandingsTable"]["StandingsLists"];

    return constructorStandingData
        .map((e) {
          return (e["ConstructorStandings"] as List).map((standing) {
            return ConstructorStanding.fromMap(standing);
          }).toList();
        })
        .expand((list) => list)
        .toList();
  } on DioException catch (error) {
    debugPrint(error.message.toString());
  }
  return constructorStandings;
}
