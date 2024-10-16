import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:formula1_data/formula1_data.dart';

/// Get results data.
/// If you want information for a specific year or round, consider using [year] or [round].
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
        final Result resultTable = Result.fromMap(data);
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
