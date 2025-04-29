import 'circuit.dart';
import 'season.dart';

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
  final String date;

  /// The time when the race is held.
  final String time;

  /// The circuit where the race is held.
  final Circuit circuit;

  /// The season to which this race belongs.
  final Season season;

  /// Creates a new [Race] instance.
  ///
  /// [raceName] is the name of the race.
  /// [round] is the round number of the race in the season.
  /// [date] is the date when the race is held.
  /// [time] is the time when the race is held.
  /// [circuit] is the circuit where the race is held.
  /// [season] is the season to which this race belongs.
  Race({
    required this.raceName,
    required this.round,
    required this.date,
    required this.time,
    required this.circuit,
    required this.season,
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
      date: json['date'],
      time: json['time'],
      circuit: Circuit.fromJson(json['Circuit']),
      season: Season.fromJson(json['Season']),
    );
  }

  @override
  String toString() {
    return 'Race(raceName: $raceName, round: $round, date: $date, time: $time, circuit: ${circuit.circuitId}, season: ${season.year})';
  }
}
