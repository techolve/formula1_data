import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:formula1_data/src/converters/schedules/schedule.dart';

@Deprecated('Use [getRaces] instead.')
Future<List<Schedule>> getSchedule({int? year}) async {
  year = year ?? DateTime.now().year;
  List<Schedule> schedules = [];

  try {
    final Dio dio = Dio();
    final Response response =
        await dio.get("https://api.jolpi.ca/ergast/f1/$year.json");
    final dynamic data = response.data;
    final List<dynamic> scheduleData = data["MRData"]["RaceTable"]["Races"];
    for (var data in scheduleData) {
      final dataMap = data as Map<String, dynamic>;
      final Schedule schedule = Schedule.fromMap(dataMap);
      schedules.add(schedule);
    }
  } on DioException catch (error) {
    debugPrint(error.message.toString());
  }

  return schedules;
}
