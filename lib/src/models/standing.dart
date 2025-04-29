import 'driver.dart';
import 'constructor.dart';

/// Represents a driver's position in the championship standings.
///
/// This class contains information about a driver's current position,
/// points, wins, and the constructors they have driven for.
class DriverStanding {
  /// The current position in the championship.
  final int position;

  /// The position as a string (can include shared positions, e.g., "1" or "1-2").
  final String positionText;

  /// The total points accumulated in the championship.
  final double points;

  /// The number of race wins in the season.
  final int wins;

  /// The driver this standing belongs to.
  final Driver driver;

  /// The list of constructors the driver has driven for in the season.
  final List<Constructor> constructors;

  /// Creates a new [DriverStanding] instance.
  ///
  /// [position] is the current championship position.
  /// [positionText] is the position as a string.
  /// [points] is the total points accumulated.
  /// [wins] is the number of race wins.
  /// [driver] is the driver this standing belongs to.
  /// [constructors] is the list of constructors the driver has driven for.
  DriverStanding({
    required this.position,
    required this.positionText,
    required this.points,
    required this.wins,
    required this.driver,
    required this.constructors,
  });

  /// Creates a [DriverStanding] instance from a JSON object.
  ///
  /// The JSON object should contain the following fields:
  /// - 'position': A string representing the position
  /// - 'positionText': A string representing the position text
  /// - 'points': A string representing the points
  /// - 'wins': A string representing the number of wins
  /// - 'Driver': An object containing driver information
  /// - 'Constructors': A list of objects containing constructor information
  factory DriverStanding.fromJson(Map<String, dynamic> json) {
    return DriverStanding(
      position: int.parse(json['position']),
      positionText: json['positionText'],
      points: double.parse(json['points']),
      wins: int.parse(json['wins']),
      driver: Driver.fromJson(json['Driver']),
      constructors: (json['Constructors'] as List)
          .map((c) => Constructor.fromJson(c))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'DriverStanding(position: $position, points: $points, driver: ${driver.driverId}, constructors: ${constructors.map((c) => c.constructorId).join(', ')})';
  }
}

/// Represents a constructor's position in the championship standings.
///
/// This class contains information about a constructor's current position,
/// points, and wins in the championship.
class ConstructorStanding {
  /// The current position in the championship.
  final int position;

  /// The position as a string (can include shared positions, e.g., "1" or "1-2").
  final String positionText;

  /// The total points accumulated in the championship.
  final double points;

  /// The number of race wins in the season.
  final int wins;

  /// The constructor this standing belongs to.
  final Constructor constructor;

  /// Creates a new [ConstructorStanding] instance.
  ///
  /// [position] is the current championship position.
  /// [positionText] is the position as a string.
  /// [points] is the total points accumulated.
  /// [wins] is the number of race wins.
  /// [constructor] is the constructor this standing belongs to.
  ConstructorStanding({
    required this.position,
    required this.positionText,
    required this.points,
    required this.wins,
    required this.constructor,
  });

  /// Creates a [ConstructorStanding] instance from a JSON object.
  ///
  /// The JSON object should contain the following fields:
  /// - 'position': A string representing the position
  /// - 'positionText': A string representing the position text
  /// - 'points': A string representing the points
  /// - 'wins': A string representing the number of wins
  /// - 'Constructor': An object containing constructor information
  factory ConstructorStanding.fromJson(Map<String, dynamic> json) {
    return ConstructorStanding(
      position: int.parse(json['position']),
      positionText: json['positionText'],
      points: double.parse(json['points']),
      wins: int.parse(json['wins']),
      constructor: Constructor.fromJson(json['Constructor']),
    );
  }

  @override
  String toString() {
    return 'ConstructorStanding(position: $position, points: $points, constructor: ${constructor.constructorId})';
  }
}
