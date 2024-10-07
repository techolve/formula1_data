import 'package:formula1_data/src/converters/results/result_table.dart';

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
}
