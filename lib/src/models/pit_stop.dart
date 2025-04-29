import 'driver.dart';
import 'constructor.dart';

/// Represents a pit stop made during a Formula 1 race.
///
/// This class contains information about a specific pit stop, including
/// the driver, constructor, stop number, lap number, time, and duration.
class PitStop {
  /// The driver who made the pit stop.
  final Driver driver;

  /// The constructor the driver was driving for.
  final Constructor constructor;

  /// The sequence number of this pit stop in the race.
  final int stop;

  /// The lap number when the pit stop was made.
  final int lap;

  /// The time of day when the pit stop was made.
  final String time;

  /// The duration of the pit stop in seconds.
  final String duration;

  /// Creates a new [PitStop] instance.
  ///
  /// [driver] is the driver who made the pit stop.
  /// [constructor] is the constructor the driver was driving for.
  /// [stop] is the sequence number of the pit stop.
  /// [lap] is the lap number when the pit stop was made.
  /// [time] is the time of day when the pit stop was made.
  /// [duration] is the duration of the pit stop in seconds.
  PitStop({
    required this.driver,
    required this.constructor,
    required this.stop,
    required this.lap,
    required this.time,
    required this.duration,
  });

  /// Creates a [PitStop] instance from a JSON object.
  ///
  /// The JSON object should contain the following fields:
  /// - 'Driver': An object containing driver information
  /// - 'Constructor': An object containing constructor information
  /// - 'stop': A string representing the stop number
  /// - 'lap': A string representing the lap number
  /// - 'time': A string representing the time
  /// - 'duration': A string representing the duration
  factory PitStop.fromJson(Map<String, dynamic> json) {
    return PitStop(
      driver: Driver.fromJson(json['Driver']),
      constructor: Constructor.fromJson(json['Constructor']),
      stop: int.parse(json['stop']),
      lap: int.parse(json['lap']),
      time: json['time'],
      duration: json['duration'],
    );
  }

  @override
  String toString() {
    return 'PitStop(driver: ${driver.driverId}, constructor: ${constructor.constructorId}, stop: $stop, lap: $lap, time: $time, duration: $duration)';
  }
}
