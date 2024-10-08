import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:formula1_data/src/converters/status/status.dart';

/// Get constructors data.
Future<List<Status>> getStatus() async {
  List<Status> status = [];
  try {
    final Dio dio = Dio();
    Map<String, dynamic> param = {"limit": 100};
    final Response response = await dio.get(
      "https://api.jolpi.ca/ergast/f1/status.json",
      queryParameters: param,
    );
    final data = response.data;
    final List<dynamic> statusData = data["MRData"]["StatusTable"]["Status"];
    for (var data in statusData) {
      final Status s = Status.fromMap(data);
      status.add(s);
      debugPrint(s.toString());
    }
  } on DioException catch (error) {
    debugPrint(error.message.toString());
  }
  return status;
}
