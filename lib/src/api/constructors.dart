import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:formula1_data/src/converters/constructor.dart';

Future<List<Constructor>> getConstructors({int? year}) async {
  year = year ?? DateTime.now().year;
  final List<Constructor> constructors = [];
  try {
    Dio dio = Dio();
    final Response response =
        await dio.get("https://ergast.com/api/f1/$year/constructors.json");

    final dynamic data = response.data;
    final List<dynamic> constructorsData =
        data["MRData"]["ConstructorTable"]["Constructors"];
    constructorsData.map((data) {
      final Constructor constructor = Constructor.fromMap(data);
      constructors.add(constructor);
    });
  } on DioException catch (error) {
    debugPrint(error.message.toString());
  }
  return constructors;
}
