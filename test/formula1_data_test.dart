import 'package:flutter_test/flutter_test.dart';

import 'package:formula1_data/formula1_data.dart';
import 'package:formula1_data/src/api/drivers.dart';
import 'package:formula1_data/src/api/results.dart';
import 'package:formula1_data/src/api/status.dart';

void main() {
  group("Get Formula1 data", () {
    test('Get constructors data', () async {
      List<Constructor> constructors = await getConstructors(year: 2024);
      expect(constructors, isNotEmpty);
      constructors.map((constructor) {
        expect(constructor.constructorsId, isNotEmpty);
      });
    });

    test('Get drivers data', () async {
      List<Driver> drivers = await getDrivers(year: 2024);
      expect(drivers, isNotEmpty);
      drivers.map((driver) {
        expect(driver.driverId, isNotEmpty);
      });
    });

    test('Get results data', () async {
      List<Race> results = await getResults(year: 2024, round: 6);
      expect(results, isNotEmpty);
    });

    test('Get status data', () async {
      List<Status> status = await getStatus();
      expect(status, isNotEmpty);
    });
  });
}
