import 'package:formula1_data/formula1_data.dart';

/// Fastest lap data
class FastestLap {
  final int rank;
  final int lap;
  final Time time;
  final AverageSpeed averageSpeed;

  const FastestLap({
    required this.rank,
    required this.lap,
    required this.time,
    required this.averageSpeed,
  });

  factory FastestLap.fromMap(dynamic map) {
    return FastestLap(
      rank: int.parse(map["rank"]),
      lap: int.parse(map["lap"]),
      time: Time.fromMap(map["Time"]),
      averageSpeed: AverageSpeed.fromMap(map["AverageSpeed"]),
    );
  }

  @override
  String toString() {
    return "FastestLap(rank: $rank, lap: $lap, time: $time, averageSpeed: $averageSpeed)";
  }
}
