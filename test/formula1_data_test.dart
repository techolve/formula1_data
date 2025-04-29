import 'package:flutter_test/flutter_test.dart';

import 'package:formula1_data/formula1_data.dart';
import 'package:logger/web.dart';

void main() {
  // Setting logger instance.
  final logger = Logger();

  group("Get Formula1 data", () {
    final currentYear = DateTime.now().year;
    test('Get schedule data', () async {
      List<Schedule> schedules = await getSchedule(year: currentYear);
      logger.i(schedules);
    });

    test('Get constructors data', () async {
      List<Constructor> constructors = await getConstructors(year: currentYear);
      logger.i(constructors);
    });

    test('Get drivers data', () async {
      List<Driver> drivers = await getDrivers(year: currentYear);
      logger.i(drivers);
    });

    test('Get results data', () async {
      List<Race> results = await getResults(year: currentYear, round: 6);
      logger.i(results);
    });

    test('Get status data', () async {
      List<Status> status = await getStatus();
      logger.i(status);
    });

    test('Get circuit data', () async {
      List<Circuit> circuits = await getCircuit();
      logger.i(circuits);
    });

    test('Get driver standing data', () async {
      List<DriverStanding> driverStandings =
          await getDriverStanding(year: currentYear);
      logger.i(driverStandings);
    });

    test('Get constructor standing data', () async {
      List<ConstructorStanding> constructorStandings =
          await getConstructorStanding(year: currentYear);
      logger.i(constructorStandings);
    });
  });
}
