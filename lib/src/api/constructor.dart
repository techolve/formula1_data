import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:formula1_data/src/converters/constructor/constructor.dart';

/// Get constructors data.
/// If you want information for a specific year, consider using [year].
Future<List<Constructor>> getConstructors({int? year}) async {
  year = year ?? DateTime.now().year;
  List<Constructor> constructors = [];
  try {
    Dio dio = Dio();
    final Response response =
        await dio.get("https://api.jolpi.ca/ergast/f1/$year/constructors.json");

    final dynamic data = response.data;
    final List<dynamic> constructorsData =
        data["MRData"]["ConstructorTable"]["Constructors"];

    for (var data in constructorsData) {
      final Constructor constructor = Constructor.fromMap(data);
      constructors.add(constructor);
    }
  } on DioException catch (error) {
    debugPrint(error.message.toString());
  }
  return constructors;
}
