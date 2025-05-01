import 'package:formula1_data/src/models/driver.dart';
import 'package:formula1_data/src/models/constructor.dart';

/// Represents a sprint result in Formula 1.
///
/// This class contains information about a driver's performance in a sprint race,
/// including their position, points earned, and various timing information.
class SprintResult {
  /// The car number of the driver.
  final int number;

  /// The finishing position of the driver.
  final int position;

  /// The position text (e.g., "1", "2", "3", "R" for retired).
  final String positionText;

  /// The points earned by the driver in this sprint.
  final double points;

  /// The driver who achieved this result.
  final Driver driver;

  /// The constructor (team) the driver was racing for.
  final Constructor constructor;

  /// The starting grid position of the driver.
  final int grid;

  /// The number of laps completed by the driver.
  final int laps;

  /// The status of the driver at the end of the sprint (e.g., "Finished", "Retired").
  final String status;

  /// The time taken to complete the sprint, if available.
  final SprintTime? time;

  /// Information about the fastest lap achieved during the sprint, if available.
  final SprintFastestLap? fastestLap;

  /// Creates a new [SprintResult] instance.
  ///
  /// [number] is the car number of the driver.
  /// [position] is the finishing position of the driver.
  /// [positionText] is the position text.
  /// [points] is the points earned by the driver.
  /// [driver] is the driver who achieved this result.
  /// [constructor] is the constructor the driver was racing for.
  /// [grid] is the starting grid position.
  /// [laps] is the number of laps completed.
  /// [status] is the status of the driver at the end of the sprint.
  /// [time] is the time taken to complete the sprint.
  /// [fastestLap] is the information about the fastest lap.
  SprintResult({
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

  /// Creates a [SprintResult] instance from a JSON object.
  ///
  /// The JSON object should contain the following fields:
  /// - 'number': A string representing the car number
  /// - 'position': A string representing the finishing position
  /// - 'positionText': A string representing the position text
  /// - 'points': A string representing the points earned
  /// - 'Driver': A map containing driver information
  /// - 'Constructor': A map containing constructor information
  /// - 'grid': A string representing the starting grid position
  /// - 'laps': A string representing the number of laps completed
  /// - 'status': A string representing the status
  /// - 'Time': A map containing time information (optional)
  /// - 'FastestLap': A map containing fastest lap information (optional)
  factory SprintResult.fromJson(Map<String, dynamic> json) {
    return SprintResult(
      number: int.parse(json['number']),
      position: int.parse(json['position']),
      positionText: json['positionText'],
      points: double.parse(json['points']),
      driver: Driver.fromJson(json['Driver']),
      constructor: Constructor.fromJson(json['Constructor']),
      grid: int.parse(json['grid']),
      laps: int.parse(json['laps']),
      status: json['status'],
      time: json['Time'] != null ? SprintTime.fromJson(json['Time']) : null,
      fastestLap: json['FastestLap'] != null
          ? SprintFastestLap.fromJson(json['FastestLap'])
          : null,
    );
  }

  @override
  String toString() {
    return 'SprintResult(number: $number, position: $position, positionText: $positionText, points: $points, driver: $driver, constructor: $constructor, grid: $grid, laps: $laps, status: $status, time: $time, fastestLap: $fastestLap)';
  }
}

/// Represents the time taken to complete a sprint race.
///
/// This class contains information about the time taken by a driver to complete a sprint race,
/// including the time in milliseconds and a formatted time string.
class SprintTime {
  /// The time in milliseconds.
  final int? millis;

  /// The formatted time string (e.g., "1:30.123").
  final String time;

  /// Creates a new [SprintTime] instance.
  ///
  /// [millis] is the time in milliseconds.
  /// [time] is the formatted time string.
  SprintTime({
    this.millis,
    required this.time,
  });

  /// Creates a [SprintTime] instance from a JSON object.
  ///
  /// The JSON object should contain the following fields:
  /// - 'millis': A string representing the time in milliseconds
  /// - 'time': A string representing the formatted time
  factory SprintTime.fromJson(Map<String, dynamic> json) {
    return SprintTime(
      millis: json['millis'] != null ? int.parse(json['millis']) : null,
      time: json['time'],
    );
  }

  @override
  String toString() {
    return 'SprintTime(millis: $millis, time: $time)';
  }
}

/// Represents the fastest lap achieved during a sprint race.
///
/// This class contains information about the fastest lap achieved by a driver during a sprint race,
/// including the lap number, time taken, and average speed.
class SprintFastestLap {
  /// The rank of this fastest lap compared to other laps.
  final int rank;

  /// The lap number on which the fastest lap was achieved.
  final int lap;

  /// The time taken to complete the fastest lap.
  final SprintTime time;

  /// The average speed during the fastest lap.
  final SprintAverageSpeed averageSpeed;

  /// Creates a new [SprintFastestLap] instance.
  ///
  /// [rank] is the rank of this fastest lap.
  /// [lap] is the lap number.
  /// [time] is the time taken to complete the lap.
  /// [averageSpeed] is the average speed during the lap.
  SprintFastestLap({
    required this.rank,
    required this.lap,
    required this.time,
    required this.averageSpeed,
  });

  /// Creates a [SprintFastestLap] instance from a JSON object.
  ///
  /// The JSON object should contain the following fields:
  /// - 'rank': A string representing the rank
  /// - 'lap': A string representing the lap number
  /// - 'Time': A map containing time information
  /// - 'AverageSpeed': A map containing average speed information
  factory SprintFastestLap.fromJson(Map<String, dynamic> json) {
    return SprintFastestLap(
      rank: int.parse(json['rank']),
      lap: int.parse(json['lap']),
      time: SprintTime.fromJson(json['Time']),
      averageSpeed: SprintAverageSpeed.fromJson(json['AverageSpeed']),
    );
  }

  @override
  String toString() {
    return 'SprintFastestLap(rank: $rank, lap: $lap, time: $time, averageSpeed: $averageSpeed)';
  }
}

/// Represents the average speed during a fastest lap in a sprint race.
///
/// This class contains information about the average speed achieved during a fastest lap,
/// including the speed value and the unit of measurement.
class SprintAverageSpeed {
  /// The speed value.
  final String speed;

  /// The unit of measurement for the speed (e.g., "kph").
  final String units;

  /// Creates a new [SprintAverageSpeed] instance.
  ///
  /// [speed] is the speed value.
  /// [units] is the unit of measurement.
  SprintAverageSpeed({
    required this.speed,
    required this.units,
  });

  /// Creates a [SprintAverageSpeed] instance from a JSON object.
  ///
  /// The JSON object should contain the following fields:
  /// - 'speed': A string representing the speed value
  /// - 'units': A string representing the unit of measurement
  factory SprintAverageSpeed.fromJson(Map<String, dynamic> json) {
    return SprintAverageSpeed(
      speed: json['speed'],
      units: json['units'],
    );
  }

  @override
  String toString() {
    return 'SprintAverageSpeed(speed: $speed, units: $units)';
  }
}
