import 'circuit.dart';

class Race {
  final int season;
  final int round;
  final String url;
  final String raceName;
  final Circuit circuit;
  final DateTime date;
  final String? time;

  Race({
    required this.season,
    required this.round,
    required this.url,
    required this.raceName,
    required this.circuit,
    required this.date,
    this.time,
  });

  factory Race.fromJson(Map<String, dynamic> json) {
    return Race(
      season: int.parse(json['season']),
      round: int.parse(json['round']),
      url: json['url'],
      raceName: json['raceName'],
      circuit: Circuit.fromJson(json['Circuit']),
      date: DateTime.parse(json['date']),
      time: json['time'],
    );
  }

  @override
  String toString() {
    return 'Race(season: $season, round: $round, url: $url, raceName: $raceName, circuit: $circuit, date: $date, time: $time)';
  }
}
