import 'package:formula1_data/formula1_data.dart';

class DriverStanding {
  final int position;
  final int points;
  final int wins;
  final Driver driver;
  final List<Constructor> constructor;

  DriverStanding({
    required this.position,
    required this.points,
    required this.wins,
    required this.driver,
    required this.constructor,
  });

  factory DriverStanding.fromMap(Map<String, dynamic> map) {
    return DriverStanding(
      position: int.parse(map['position']),
      points: int.parse(map['points']),
      wins: int.parse(map['wins']),
      driver: Driver.fromMap(map['Driver']),
      constructor: (map['Constructors'] as List)
          .map((e) => Constructor.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() {
    return "DriverStanding(position: $position, points: $points, wins: $wins, driver: $driver, constructor: $constructor)";
  }
}
