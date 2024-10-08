/// Average speed data
class AverageSpeed {
  final String units;
  final double speed;

  AverageSpeed({
    required this.units,
    required this.speed,
  });

  factory AverageSpeed.fromMap(dynamic map) {
    return AverageSpeed(
      units: map["units"],
      speed: double.parse(map["speed"]),
    );
  }

  @override
  String toString() {
    return "AverageSpeed(units: $units, speed: $speed)";
  }
}
