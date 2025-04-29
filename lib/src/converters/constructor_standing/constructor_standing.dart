import 'package:formula1_data/formula1_data.dart';

class ConstructorStanding {
  final int position;
  final int points;
  final int wins;
  final Constructor constructor;

  ConstructorStanding({
    required this.position,
    required this.points,
    required this.wins,
    required this.constructor,
  });

  factory ConstructorStanding.fromMap(Map<String, dynamic> map) {
    return ConstructorStanding(
      position: int.parse(map['position']),
      points: int.parse(map['points']),
      wins: int.parse(map['wins']),
      constructor: Constructor.fromMap(map['Constructor']),
    );
  }

  @override
  String toString() {
    return "ConstructorStanding(position: $position, points: $points, wins: $wins, constructor: $constructor)";
  }
}
