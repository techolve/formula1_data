import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:formula1_data/formula1_data.dart';

Future<List<Race>> getResults({int? year, int? round}) async {
  year = year ?? DateTime.now().year;
  List<Race> results = [];

  try {
    Dio dio = Dio();
    final Response response = await dio
        .get("https://api.jolpi.ca/ergast/f1/$year/$round/results.json");
    final dynamic data = response.data;
    final List<dynamic> racesData = data["MRData"]["RaceTable"]["Races"];
    for (var race in racesData) {
      final List<dynamic> resultsData = race["Results"];
      final List<Result> resultsArray = [];
      for (var data in resultsData) {
        final dataMap = data as Map<String, dynamic>;

        final Result resultTable = Result(
          number: int.parse(dataMap["number"]),
          position: int.parse(dataMap["position"]),
          positionText: dataMap["positionText"],
          points: int.parse(dataMap["points"]),
          driver: Driver.fromMap(dataMap["Driver"]),
          constructor: Constructor.fromMap(dataMap["Constructor"]),
          grid: int.parse(dataMap["grid"]),
          laps: int.parse(dataMap["laps"]),
          status: dataMap["status"],
          time: dataMap.containsKey("Time")
              ? Time.fromMap(dataMap["Time"])
              : null,
          fastestLap: dataMap.containsKey("FastestLap")
              ? FastestLap.fromMap(dataMap["FastestLap"])
              : null,
        );
        resultsArray.add(resultTable);
      }
      final Race result = Race(
        season: int.parse(race["season"]),
        round: int.parse(race["round"]),
        url: race["url"],
        raceName: race["raceName"],
        resultTable: resultsArray,
      );
      results.add(result);
    }
  } on DioException catch (error) {
    debugPrint(error.message.toString());
  }

  return results;
}
