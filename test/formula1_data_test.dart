import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:formula1_data/formula1_data.dart';
import 'package:formula1_data/src/api/drivers.dart';
import 'package:formula1_data/src/api/results.dart';
import 'package:formula1_data/src/api/schedules.dart';
import 'package:formula1_data/src/api/status.dart';
import 'package:formula1_data/src/converters/schedules/schedule.dart';
import 'package:logger/web.dart';

void main() {
  // Setting logger instance.
  final logger = Logger();

  group("Get Formula1 data", () {
    test('Get schedule data', () async {
      List<Schedule> schedules = await getSchedule(year: 2024);
      logger.i(schedules);
    });

    test('Get constructors data', () async {
      List<Constructor> constructors = await getConstructors(year: 2024);
      logger.i(constructors);
    });

    test('Get drivers data', () async {
      List<Driver> drivers = await getDrivers(year: 2024);
      logger.i(drivers);
    });

    test('Get results data', () async {
      List<Race> results = await getResults(year: 2024, round: 6);
      logger.i(results);
    });

    test('Get status data', () async {
      List<Status> status = await getStatus();
      logger.i(status);
    });
  });
}
