import 'circuit.dart';

/// Represents a Formula 1 race.
///
/// This class contains information about a specific race in a Formula 1 season,
/// including its name, round number, date, time, circuit details, and season information.
class Race {
  /// The name of the race.
  final String raceName;

  /// The round number of the race in the season.
  final int round;

  /// The date when the race is held.
  final DateTime dateTime;

  /// The circuit where the race is held.
  final Circuit circuit;

  /// The season to which this race belongs.
  final int season;

  /// Creates a new [Race] instance.
  ///
  /// [raceName] is the name of the race.
  /// [round] is the round number of the race in the season.
  /// [dateTime] is the date and time when the race is held.
  /// [circuit] is the circuit where the race is held.
  /// [season] is the season to which this race belongs.
  Race({
    required this.season,
    required this.raceName,
    required this.round,
    required this.dateTime,
    required this.circuit,
  });

  /// Creates a [Race] instance from a JSON object.
  ///
  /// The JSON object should contain the following fields:
  /// - 'raceName': A string representing the race name
  /// - 'round': A string representing the round number
  /// - 'date': A string representing the race date
  /// - 'time': A string representing the race time
  /// - 'Circuit': An object containing circuit information
  /// - 'Season': An object containing season information
  factory Race.fromJson(Map<String, dynamic> json) {
    return Race(
      raceName: json['raceName'],
      round: int.parse(json['round']),
      dateTime: DateTime.parse('${json['date']} ${json['time']}'),
      circuit: Circuit.fromJson(json['Circuit']),
      season: int.parse(json['season']),
    );
  }

  @override
  String toString() {
    return 'Race(raceName: $raceName, round: $round, dateTime: $dateTime, circuit: ${circuit.circuitId}, season: $season)';
  }
}
