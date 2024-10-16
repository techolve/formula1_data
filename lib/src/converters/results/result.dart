import 'package:formula1_data/src/converters/results/result_table.dart';

/// Race data
class Race {
  final int season;
  final int round;
  final String url;
  final String raceName;
  final List<Result> resultTable;

  Race({
    required this.season,
    required this.round,
    required this.url,
    required this.raceName,
    required this.resultTable,
  });

  @override
  String toString() {
    return "Race(season: $season, round: $round, url: $url, raceName: $raceName, resultTable: $resultTable)";
  }
}
