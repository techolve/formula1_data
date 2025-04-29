import 'driver.dart';
import 'constructor.dart';

/// Represents a lap time recorded during a Formula 1 race.
///
/// This class contains information about a specific lap, including
/// the lap number, position, driver, constructor, time, and rank.
class LapTime {
  /// The lap number this time was recorded on.
  final int number;

  /// The position of the driver at the time of this lap.
  final int position;

  /// The driver who recorded this lap time.
  final Driver driver;

  /// The constructor the driver was driving for.
  final Constructor constructor;

  /// The time taken to complete the lap.
  final String time;

  /// The rank of this lap time compared to other laps (if available).
  final int? rank;

  /// Creates a new [LapTime] instance.
  ///
  /// [number] is the lap number.
  /// [position] is the driver's position at the time.
  /// [driver] is the driver who recorded the lap.
  /// [constructor] is the constructor the driver was driving for.
  /// [time] is the lap time.
  /// [rank] is the rank of this lap time (optional).
  LapTime({
    required this.number,
    required this.position,
    required this.driver,
    required this.constructor,
    required this.time,
    this.rank,
  });

  /// Creates a [LapTime] instance from a JSON object.
  ///
  /// The JSON object should contain the following fields:
  /// - 'number': A string representing the lap number
  /// - 'position': A string representing the position
  /// - 'Driver': An object containing driver information
  /// - 'Constructor': An object containing constructor information
  /// - 'time': A string representing the lap time
  /// - 'rank': A string representing the rank (optional)
  factory LapTime.fromJson(Map<String, dynamic> json) {
    return LapTime(
      number: int.parse(json['number']),
      position: int.parse(json['position']),
      driver: Driver.fromJson(json['Driver']),
      constructor: Constructor.fromJson(json['Constructor']),
      time: json['time'],
      rank: json['rank'] != null ? int.parse(json['rank']) : null,
    );
  }

  @override
  String toString() {
    return 'LapTime(number: $number, position: $position, driver: ${driver.driverId}, constructor: ${constructor.constructorId}, time: $time, rank: $rank)';
  }
}
