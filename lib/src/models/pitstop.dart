import 'driver.dart';
import 'constructor.dart';

class PitStop {
  final int stop;
  final int lap;
  final String time;
  final String duration;
  final Driver driver;
  final Constructor constructor;

  PitStop({
    required this.stop,
    required this.lap,
    required this.time,
    required this.duration,
    required this.driver,
    required this.constructor,
  });

  factory PitStop.fromJson(Map<String, dynamic> json) {
    return PitStop(
      stop: int.parse(json['stop']),
      lap: int.parse(json['lap']),
      time: json['time'],
      duration: json['duration'],
      driver: Driver.fromJson(json['Driver']),
      constructor: Constructor.fromJson(json['Constructor']),
    );
  }

  @override
  String toString() {
    return 'PitStop(stop: $stop, lap: $lap, time: $time, duration: $duration, driver: ${driver.driverId}, constructor: ${constructor.constructorId})';
  }
}
