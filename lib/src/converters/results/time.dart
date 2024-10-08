/// Time data
class Time {
  final int? millis;
  final String time;

  const Time({
    this.millis,
    required this.time,
  });

  factory Time.fromMap(dynamic map) {
    final data = map as Map<String, dynamic>;
    if (data.isNotEmpty && data.containsKey("millis")) {
      return Time(
        millis: int.parse(map["millis"]!),
        time: map["time"]!,
      );
    } else {
      return Time(time: map["time"]!);
    }
  }

  @override
  String toString() {
    return "Time(millis: $millis, time: $time)";
  }
}
