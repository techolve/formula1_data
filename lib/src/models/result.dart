import 'driver.dart';
import 'constructor.dart';

class RaceResult {
  final int number;
  final int position;
  final String positionText;
  final int points;
  final Driver driver;
  final Constructor constructor;
  final int grid;
  final int laps;
  final String status;
  final ResultTime? time;
  final FastestLap? fastestLap;

  RaceResult({
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

  factory RaceResult.fromJson(Map<String, dynamic> json) {
    return RaceResult(
      number: int.parse(json['number']),
      position: int.parse(json['position']),
      positionText: json['positionText'],
      points: int.parse(json['points']),
      driver: Driver.fromJson(json['Driver']),
      constructor: Constructor.fromJson(json['Constructor']),
      grid: int.parse(json['grid']),
      laps: int.parse(json['laps']),
      status: json['status'],
      time: json['Time'] != null ? ResultTime.fromJson(json['Time']) : null,
      fastestLap: json['FastestLap'] != null
          ? FastestLap.fromJson(json['FastestLap'])
          : null,
    );
  }

  @override
  String toString() {
    return 'RaceResult(position: $position, driver: ${driver.givenName} ${driver.familyName}, constructor: ${constructor.name}, points: $points)';
  }
}

class ResultTime {
  final int? millis;
  final String time;

  ResultTime({
    this.millis,
    required this.time,
  });

  factory ResultTime.fromJson(Map<String, dynamic> json) {
    return ResultTime(
      millis: json['millis'] != null ? int.parse(json['millis']) : null,
      time: json['time'],
    );
  }
}

class FastestLap {
  final int rank;
  final int lap;
  final ResultTime time;
  final AverageSpeed averageSpeed;

  FastestLap({
    required this.rank,
    required this.lap,
    required this.time,
    required this.averageSpeed,
  });

  factory FastestLap.fromJson(Map<String, dynamic> json) {
    return FastestLap(
      rank: int.parse(json['rank']),
      lap: int.parse(json['lap']),
      time: ResultTime.fromJson(json['Time']),
      averageSpeed: AverageSpeed.fromJson(json['AverageSpeed']),
    );
  }
}

class AverageSpeed {
  final String units;
  final double speed;

  AverageSpeed({
    required this.units,
    required this.speed,
  });

  factory AverageSpeed.fromJson(Map<String, dynamic> json) {
    return AverageSpeed(
      units: json['units'],
      speed: double.parse(json['speed']),
    );
  }
}
