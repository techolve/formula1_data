import 'package:formula1_data/src/converters/circuits/circuit.dart';
import 'package:formula1_data/src/converters/schedules/first_practice.dart';
import 'package:formula1_data/src/converters/schedules/qualifying.dart';
import 'package:formula1_data/src/converters/schedules/second_practice.dart';
import 'package:formula1_data/src/converters/schedules/sprint.dart';
import 'package:formula1_data/src/converters/schedules/third_practice.dart';

class Schedule {
  final int season;
  final int round;
  final String url;
  final String raceName;
  final Circuit circuit;
  final DateTime dateTime;
  final FirstPractice firstPractice;
  final Sprint? sprint;
  final SecondPractice? secondPractice;
  final ThirdPractice? thirdPractice;
  final Qualifying qualifying;

  Schedule({
    required this.season,
    required this.round,
    required this.url,
    required this.raceName,
    required this.circuit,
    required this.dateTime,
    required this.firstPractice,
    this.sprint,
    this.secondPractice,
    this.thirdPractice,
    required this.qualifying,
  });

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      season: int.parse(map["season"]),
      round: int.parse(map["round"]),
      url: map["url"],
      raceName: map["raceName"],
      circuit: Circuit.fromMap(map["Circuit"]),
      dateTime: DateTime.parse("${map["date"]} ${map["time"]}"),
      firstPractice: FirstPractice.fromMap(map["FirstPractice"]),
      sprint: map.containsKey("Sprint") ? Sprint.fromMap(map["Sprint"]) : null,
      secondPractice: map.containsKey("SecondPractice")
          ? SecondPractice.fromMap(map["SecondPractice"])
          : null,
      thirdPractice: map.containsKey("ThirdPractice")
          ? ThirdPractice.fromMap(map["ThirdPractice"])
          : null,
      qualifying: Qualifying.fromMap(map["Qualifying"]),
    );
  }

  @override
  String toString() {
    return "Schedule(season: $season, round: $round, url: $url, raceName: $raceName, circuit: $circuit, dateTime: $dateTime, firstPractice: $firstPractice, secondPractice: $secondPractice, thirdPractice: $thirdPractice, qualifying: $qualifying)";
  }
}
