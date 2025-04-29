import 'driver.dart';
import 'constructor.dart';

/// Represents a qualifying result for a Formula 1 race.
///
/// This class contains information about a driver's qualifying performance,
/// including their position, number, driver details, constructor details,
/// and their times for Q1, Q2, and Q3 sessions.
class QualifyingResult {
  /// The position achieved in qualifying.
  final int position;

  /// The driver's number.
  final int number;

  /// The driver who achieved this qualifying result.
  final Driver driver;

  /// The constructor the driver was driving for.
  final Constructor constructor;

  /// The time achieved in Q1 session.
  final String q1;

  /// The time achieved in Q2 session, if applicable.
  final String? q2;

  /// The time achieved in Q3 session, if applicable.
  final String? q3;

  /// Creates a new [QualifyingResult] instance.
  ///
  /// [position] is the position achieved in qualifying.
  /// [number] is the driver's number.
  /// [driver] is the driver who achieved this result.
  /// [constructor] is the constructor the driver was driving for.
  /// [q1] is the time achieved in Q1 session.
  /// [q2] is the time achieved in Q2 session, if applicable.
  /// [q3] is the time achieved in Q3 session, if applicable.
  QualifyingResult({
    required this.position,
    required this.number,
    required this.driver,
    required this.constructor,
    required this.q1,
    this.q2,
    this.q3,
  });

  /// Creates a [QualifyingResult] instance from a JSON object.
  ///
  /// The JSON object should contain the following fields:
  /// - 'position': A string representing the position
  /// - 'number': A string representing the driver number
  /// - 'Driver': An object containing driver information
  /// - 'Constructor': An object containing constructor information
  /// - 'Q1': A string representing the Q1 time
  /// - 'Q2': A string representing the Q2 time (optional)
  /// - 'Q3': A string representing the Q3 time (optional)
  factory QualifyingResult.fromJson(Map<String, dynamic> json) {
    return QualifyingResult(
      position: int.parse(json['position']),
      number: int.parse(json['number']),
      driver: Driver.fromJson(json['Driver']),
      constructor: Constructor.fromJson(json['Constructor']),
      q1: json['Q1'],
      q2: json['Q2'],
      q3: json['Q3'],
    );
  }

  @override
  String toString() {
    return 'QualifyingResult(position: $position, number: $number, driver: ${driver.driverId}, constructor: ${constructor.constructorId}, q1: $q1, q2: $q2, q3: $q3)';
  }
}
