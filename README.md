# formula1_data

A Dart package of Formula1&trade;.

## Sample

Here are some examples of how to use the package:

```dart
import 'package:formula1_data/formula1_data.dart';

void main() async {
  final formula1 = Formula1Data();

  // Get all seasons
  final seasons = await formula1.getSeasons();
  print('Seasons: ${seasons?.map((s) => s.year).join(', ')}');

  // Get all circuits
  final circuits = await formula1.getCircuits();
  print('Circuits: ${circuits?.map((c) => c.name).join(', ')}');

  // Get races for a specific season
  final races = await formula1.getRaces(season: 2023);
  print('Races in 2023: ${races?.map((r) => r.raceName).join(', ')}');

  // Get race results for a specific race
  final results = await formula1.getResults(season: 2023, round: 1);
  print('Race results: ${results?.map((r) => '${r.driver.givenName} ${r.driver.familyName}: ${r.position}').join(', ')}');

  // Get driver standings
  final driverStandings = await formula1.getDriverStandings(year: 2023);
  print('Driver standings: ${driverStandings?.map((s) => '${s.driver.givenName} ${s.driver.familyName}: ${s.points}').join(', ')}');

  // Get constructor standings
  final constructorStandings = await formula1.getConstructorStandings(year: 2023);
  print('Constructor standings: ${constructorStandings?.map((s) => '${s.constructor.name}: ${s.points}').join(', ')}');

  // Get qualifying results
  final qualifying = await formula1.getQualifying(year: 2023, round: 1);
  print('Qualifying results: ${qualifying?.map((q) => '${q.driver.givenName} ${q.driver.familyName}: ${q.position}').join(', ')}');

  // Get sprint results
  final sprint = await formula1.getSprint(year: 2023, round: 1);
  print('Sprint results: ${sprint?.map((s) => '${s.driver.givenName} ${s.driver.familyName}: ${s.position}').join(', ')}');

  // Get pit stops
  final pitStops = await formula1.getPitStops(year: 2023, round: 1);
  print('Pit stops: ${pitStops?.map((p) => '${p.driverId}: ${p.duration}').join(', ')}');

  // Get lap times
  final lapTimes = await formula1.getLapTimes(year: 2023, round: 1);
  print('Lap times: ${lapTimes?.map((l) => '${l.driverId}: ${l.time}').join(', ')}');

  // Get race status
  final status = await formula1.getStatus(year: 2023);
  print('Race status: ${status?.map((s) => '${s.status}: ${s.count}').join(', ')}');
}
```

## Dataset License

Basically, the datasets are licensed under [Apache License 2.0](https://github.com/jolpica/jolpica-f1/blob/main/LICENSE)

1. [jolpica-f1](https://github.com/jolpica/jolpica-f1/blob/main/docs/README.md)
