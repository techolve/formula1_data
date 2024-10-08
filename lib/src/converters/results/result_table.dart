import 'package:formula1_data/src/converters/constructors/constructor.dart';
import 'package:formula1_data/src/converters/drivers/driver.dart';
import 'package:formula1_data/src/converters/results/fastest_lap.dart';
import 'package:formula1_data/src/converters/results/time.dart';

/// Race result data
class Result {
  final int number;
  final int position;
  final String positionText;
  final int points;
  final Driver driver;
  final Constructor constructor;
  final int grid;
  final int laps;
  final String status;
  final Time? time;
  final FastestLap? fastestLap;

  const Result({
    required this.number,
    required this.position,
    required this.positionText,
    required this.points,
    required this.driver,
    required this.constructor,
    required this.grid,
    required this.laps,
    required this.status,
    this.time,
    this.fastestLap,
  });

  factory Result.fromMap(dynamic map) {
    return Result(
      number: map["number"],
      position: map["position"],
      positionText: map["positionText"],
      points: map["points"],
      driver: map["driver"],
      constructor: map["constructor"],
      grid: map["grid"],
      laps: map["laps"],
      status: map["status"],
      time: map["time"],
      fastestLap: map["fastestLap"],
    );
  }

  @override
  String toString() {
    return "ResultTable(number: $number, position: $position, positionText: $positionText, points: $points, driver: $driver, constructor: $constructor, grid: $grid, laps: $laps, status: $status, time: $time, fastestLap: $fastestLap)";
  }
}
