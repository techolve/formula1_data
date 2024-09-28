import 'package:formula1_data/src/results/result_table.dart';

class Result {
  final int season;
  final int round;
  final String url;
  final String raceName;
  final ResultTable resultTable;

  Result({
    required this.season,
    required this.round,
    required this.url,
    required this.raceName,
    required this.resultTable,
  });
}
