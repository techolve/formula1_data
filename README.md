# formula1_data

A Dart package of Formula1&trade;.

## Sample

Here are some examples of how to use the package:

```dart
import 'package:formula1_data/formula1_data.dart';

void main() async {
  // The jolpica-f1 API requires a custom User-Agent identifying your app.
  final formula1 = Formula1Data(userAgent: 'MyApp/1.0.0');

  // Get all seasons
  final seasons = await formula1.getSeasons();
  print('Seasons: ${seasons.items.map((s) => s.year).join(', ')}');

  // Get all circuits
  final circuits = await formula1.getCircuits();
  print('Circuits: ${circuits.items.map((c) => c.circuitName).join(', ')}');

  // Get races for a specific season
  final races = await formula1.getRaces(season: 2023);
  print('Races in 2023: ${races.items.map((r) => r.raceName).join(', ')}');

  // Get race results for a specific race
  final results = await formula1.getResults(season: 2023, round: 1);
  print('Race results: ${results.items.map((r) => '${r.driver.givenName} ${r.driver.familyName}: ${r.position}').join(', ')}');

  // Get driver standings
  final driverStandings = await formula1.getDriverStandings(year: 2023);
  print('Driver standings: ${driverStandings.items.map((s) => '${s.driver.givenName} ${s.driver.familyName}: ${s.points}').join(', ')}');

  // Get constructor standings
  final constructorStandings = await formula1.getConstructorStandings(year: 2023);
  print('Constructor standings: ${constructorStandings.items.map((s) => '${s.constructor.name}: ${s.points}').join(', ')}');

  // Get qualifying results
  final qualifying = await formula1.getQualifying(year: 2023, round: 1);
  print('Qualifying results: ${qualifying.items.map((q) => '${q.driver.givenName} ${q.driver.familyName}: ${q.position}').join(', ')}');

  // Get sprint results
  final sprint = await formula1.getSprint(year: 2023, round: 1);
  print('Sprint results: ${sprint.items.map((s) => '${s.driver.givenName} ${s.driver.familyName}: ${s.position}').join(', ')}');

  // Get pit stops
  final pitStops = await formula1.getPitStops(year: 2023, round: 1);
  print('Pit stops: ${pitStops.items.map((p) => '${p.driver.driverId}: ${p.duration}').join(', ')}');

  // Get lap times
  final laps = await formula1.getLaps(year: 2023, round: 1);
  print('Lap times: ${laps.items.map((l) => '${l.driverId}: ${l.time}').join(', ')}');

  // Get race status
  final status = await formula1.getStatus(year: 2023);
  print('Race status: ${status.items.map((s) => '${s.status}: ${s.count}').join(', ')}');
}
```

## Pagination

Every method returns a `PaginatedResult<T>`, which bundles the page of
`items` with the `total` number of items available, and the `limit`/`offset`
that were actually applied by the API. Pass `offset`/`limit` to page through
more than the default 30 items (max 100 per request):

```dart
final seasons = await formula1.getSeasons(offset: 30, limit: 50);
print('${seasons.items.length} of ${seasons.total} seasons, hasMore: ${seasons.hasMore}');
```

## Dataset License

Basically, the datasets are licensed under [Apache License 2.0](https://github.com/jolpica/jolpica-f1/blob/main/LICENSE)

1. [jolpica-f1](https://github.com/jolpica/jolpica-f1/blob/main/docs/README.md)
