import 'driver.dart';
import 'constructor.dart';

/// Represents a race result in Formula 1.
///
/// This class contains information about a driver's performance in a race,
/// including their finishing position, points earned, and various race statistics.
class RaceResult {
  /// The number of the car.
  final int number;

  /// The finishing position of the driver.
  final int position;

  /// The position text (e.g., "1", "2", "DNF").
  final String positionText;

  /// The number of points earned in the race.
  final int points;

  /// The driver who achieved this result.
  final Driver driver;

  /// The constructor (team) the driver was racing for.
  final Constructor constructor;

  /// The starting grid position.
  final int grid;

  /// The number of laps completed.
  final int laps;

  /// The status of the driver at the end of the race (e.g., "Finished", "Retired").
  final String status;

  /// The time taken to complete the race, if available.
  final ResultTime? time;

  /// The fastest lap achieved during the race, if available.
  final FastestLap? fastestLap;

  /// Creates a new [RaceResult] instance.
  ///
  /// [number] is the car number.
  /// [position] is the finishing position.
  /// [positionText] is the position text.
  /// [points] is the number of points earned.
  /// [driver] is the driver who achieved this result.
  /// [constructor] is the constructor (team) the driver was racing for.
  /// [grid] is the starting grid position.
  /// [laps] is the number of laps completed.
  /// [status] is the status of the driver at the end of the race.
  /// [time] is the time taken to complete the race, if available.
  /// [fastestLap] is the fastest lap achieved during the race, if available.
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

  /// Creates a [RaceResult] instance from a JSON object.
  ///
  /// The JSON object should contain the following fields:
  /// - 'number': A string representing the car number
  /// - 'position': A string representing the finishing position
  /// - 'positionText': A string representing the position text
  /// - 'points': A string representing the points earned
  /// - 'Driver': An object containing driver information
  /// - 'Constructor': An object containing constructor information
  /// - 'grid': A string representing the starting grid position
  /// - 'laps': A string representing the number of laps completed
  /// - 'status': A string representing the status
  /// - 'Time': An optional object containing time information
  /// - 'FastestLap': An optional object containing fastest lap information
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

/// Represents the time taken to complete a race.
class ResultTime {
  /// The time in milliseconds.
  final int? millis;

  /// The time as a string (e.g., "1:30:45.123").
  final String time;

  /// Creates a new [ResultTime] instance.
  ///
  /// [millis] is the time in milliseconds.
  /// [time] is the time as a string.
  ResultTime({
    this.millis,
    required this.time,
  });

  /// Creates a [ResultTime] instance from a JSON object.
  ///
  /// The JSON object should contain the following fields:
  /// - 'millis': A string representing the time in milliseconds
  /// - 'time': A string representing the time
  factory ResultTime.fromJson(Map<String, dynamic> json) {
    return ResultTime(
      millis: json['millis'] != null ? int.parse(json['millis']) : null,
      time: json['time'],
    );
  }

  @override
  String toString() {
    return 'ResultTime(millis: $millis, time: $time)';
  }
}

/// Represents the fastest lap achieved during a race.
class FastestLap {
  /// The lap number when the fastest lap was achieved.
  final int rank;

  /// The lap number when the fastest lap was achieved.
  final int lap;

  /// The time taken to complete the fastest lap.
  final ResultTime time;

  /// The average speed during the fastest lap.
  final AverageSpeed averageSpeed;

  /// Creates a new [FastestLap] instance.
  ///
  /// [rank] is the lap number when the fastest lap was achieved.
  /// [lap] is the lap number when the fastest lap was achieved.
  /// [time] is the time taken to complete the fastest lap.
  /// [averageSpeed] is the average speed during the fastest lap.
  FastestLap({
    required this.rank,
    required this.lap,
    required this.time,
    required this.averageSpeed,
  });

  /// Creates a [FastestLap] instance from a JSON object.
  ///
  /// The JSON object should contain the following fields:
  /// - 'rank': A string representing the lap number
  /// - 'lap': A string representing the lap number
  /// - 'time': An object containing time information
  /// - 'AverageSpeed': An object containing average speed information
  factory FastestLap.fromJson(Map<String, dynamic> json) {
    return FastestLap(
      rank: int.parse(json['rank']),
      lap: int.parse(json['lap']),
      time: ResultTime.fromJson(json['Time']),
      averageSpeed: AverageSpeed.fromJson(json['AverageSpeed']),
    );
  }

  @override
  String toString() {
    return 'FastestLap(rank: $rank, lap: $lap, time: $time, averageSpeed: $averageSpeed)';
  }
}

/// Represents the average speed during a lap.
class AverageSpeed {
  /// The speed in kilometers per hour.
  final String units;

  /// The speed in kilometers per hour.
  final double speed;

  /// Creates a new [AverageSpeed] instance.
  ///
  /// [units] is the speed in kilometers per hour.
  /// [speed] is the speed in kilometers per hour.
  AverageSpeed({
    required this.units,
    required this.speed,
  });

  /// Creates a [AverageSpeed] instance from a JSON object.
  ///
  /// The JSON object should contain the following fields:
  /// - 'units': A string representing the speed in kilometers per hour
  /// - 'speed': A string representing the speed in kilometers per hour
  factory AverageSpeed.fromJson(Map<String, dynamic> json) {
    return AverageSpeed(
      units: json['units'],
      speed: double.parse(json['speed']),
    );
  }

  @override
  String toString() {
    return 'AverageSpeed(units: $units, speed: $speed)';
  }
}
