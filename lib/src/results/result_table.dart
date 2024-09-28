import 'package:formula1_data/src/converters/constructor.dart';
import 'package:formula1_data/src/drivers/driver.dart';
import 'package:formula1_data/src/results/fastest_lap.dart';
import 'package:formula1_data/src/results/time.dart';

class ResultTable {
  final int number;
  final int position;
  final String positionText;
  final int points;
  final Driver driver;
  final Constructor constructor;
  final int grid;
  final int laps;
  final String status;
  final Time time;
  final FastestLap fastestLap;

  const ResultTable({
    required this.number,
    required this.position,
    required this.positionText,
    required this.points,
    required this.driver,
    required this.constructor,
    required this.grid,
    required this.laps,
    required this.status,
    required this.time,
    required this.fastestLap,
  });
}
