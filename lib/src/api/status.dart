import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:formula1_data/src/converters/status/status.dart';

Future<List<Status>> getStatus() async {
  List<Status> status = [];
  try {
    final Dio dio = Dio();
    final Response response =
        await dio.get("http://ergast.com/api/f1/status.json");
    final data = response.data;
    final List<dynamic> statusData = data["MRData"]["StatusTable"]["Status"];
    for (var data in statusData) {
      final Status s = Status.fromMap(data);
      status.add(s);
    }
  } on DioException catch (error) {
    debugPrint(error.message.toString());
  }
  return status;
}
