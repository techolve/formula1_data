import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:formula1_data/formula1_data.dart';
import 'package:formula1_data/src/service/dio_client.dart';

Future<List<DriverStanding>> getDriverStanding({int? year}) async {
  year = year ?? DateTime.now().year;
  List<DriverStanding> driverStandings = [];
  try {
    final response = await DioClient().dio.get('/$year/driverStandings.json');

    final dynamic data = response.data;
    final List<dynamic> driverStandingData =
        data["MRData"]["StandingsTable"]["StandingsLists"];

    // return driverStandingData.map((e) => {DriverStanding.fromMap(e)}).toList();
    return driverStandingData
        .map((e) {
          return (e["DriverStandings"] as List).map((standing) {
            return DriverStanding.fromMap(standing);
          }).toList();
        })
        .expand((list) => list)
        .toList();
  } on DioException catch (error) {
    debugPrint(error.message.toString());
  }
  return driverStandings;
}
