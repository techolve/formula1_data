import 'driver.dart';
import 'constructor.dart';

/// Represents a lap time recorded during a Formula 1 race.
///
/// This class contains information about a specific lap, including
/// the lap number, position, driver, constructor, time, and rank.
class LapTime {
  /// The lap number this time was recorded on.
  final String driverId;

  /// The position of the driver at the time of this lap.
  final int position;

  /// The time taken to complete the lap.
  final String time;

  /// Creates a new [LapTime] instance.
  ///
  /// [driverId] is the driver's ID.
  /// [position] is the driver's position at the time.
  /// [time] is the lap time.
  LapTime({
    required this.driverId,
    required this.position,
    required this.time,
  });

  /// Creates a [LapTime] instance from a JSON object.
  ///
  /// The JSON object should contain the following fields:
  /// - 'number': A string representing the lap number
  /// - 'position': A string representing the position
  /// - 'Driver': An object containing driver information
  /// - 'Constructor': An object containing constructor information
  /// - 'time': A string representing the lap time
  factory LapTime.fromJson(Map<String, dynamic> json) {
    return LapTime(
      driverId: json['driverId'],
      position: int.parse(json['position']),
      time: json['time'],
    );
  }

  @override
  String toString() {
    return 'LapTime(driverId: $driverId, position: $position, time: $time)';
  }
}
