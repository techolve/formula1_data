import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:formula1_data/formula1_data.dart';

/// Get divers data.
/// If you want information for a specific year, consider using [year].
Future<List<Driver>> getDrivers({int? year}) async {
  year = year ?? DateTime.now().year;
  List<Driver> drivers = [];
  try {
    Dio dio = Dio();
    final Response response =
        await dio.get("https://api.jolpi.ca/ergast/f1/$year/drivers.json");
    final dynamic data = response.data;
    final List<dynamic> driversData = data["MRData"]["DriverTable"]["Drivers"];
    for (var data in driversData) {
      final Driver driver = Driver.fromMap(data);
      drivers.add(driver);
    }
  } on DioException catch (error) {
    debugPrint(error.message.toString());
  }
  return drivers;
}
