import 'package:flutter/material.dart';
import 'package:formula1_data/formula1_data.dart';
import 'package:formula1_data/src/api/results.dart';

class ResultTable extends StatefulWidget {
  const ResultTable({super.key});

  @override
  State<ResultTable> createState() => _ResultTableState();
}

class _ResultTableState extends State<ResultTable> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getResults(),
        builder: (BuildContext context, AsyncSnapshot<List<Race>> snapshot) {
          if (snapshot.hasData) {
            List<Race> races = snapshot.data ?? [];
            final List<DataColumn> columns = <DataColumn>[
              const DataColumn(label: Text('Pos.')),
              const DataColumn(label: Text('Driver')),
              const DataColumn(label: Text('Nationality')),
              const DataColumn(label: Text('Team')),
              const DataColumn(label: Text('Grid')),
              const DataColumn(label: Text('Status')),
              const DataColumn(label: Text('Points'), numeric: true),
            ];
            final List<DataRow> rows = setData(races);
            return SingleChildScrollView(
              child: DataTable(columns: columns, rows: rows),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("予期せぬエラーが発生しました。"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

List<DataRow> setData(List<Race> races) {
  List<DataRow> rows = [];
  races.map((Race race) {
    List<Result> table = race.resultTable;
    table.map((Result data) {
      rows.add(DataRow(cells: <DataCell>[
        DataCell(Text(data.positionText)),
        DataCell(Text("${data.driver.familyName} ${data.driver.givenName}")),
        DataCell(Text(data.driver.nationality)),
        DataCell(Text(data.constructor.name)),
        DataCell(Text(data.grid.toString())),
        DataCell(Text(data.status)),
        DataCell(Text(data.points.toString())),
      ]));
    }).toList();
  });
  return rows;
}
