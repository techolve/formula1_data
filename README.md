# formula1_data

A Dart package of Formula1&trade;.

## Sample
### Constructors
Get Constructors data.

```dart
import 'package:/formula1_data/formula1_data.dart';

final year = DateTime.now().year;
final constructors = await getConstructors(year: year);
print(constructors.toString());
```

### Drivers
Get Drivers data.

```dart
import 'package:/formula1_data/formula1_data.dart';

final year = DateTime.now().year;
final drivers = await getDrivers(year: year);
print(drivers.toString());
```

### Results
Get Results data.

```dart
import 'package:/formula1_data/formula1_data.dart';

final year = DateTime.now().year;
final int round = 1;
final results = await getResults(year: year, round: round);
print(results.toString());
```

### Status
Get Status data.

```dart
import 'package:/formula1_data/formula1_data.dart';

final status = await getStatus();
print(status.toString());
```

## Dataset License
Basically, the datasets are licensed under [Apache License 2.0](https://github.com/jolpica/jolpica-f1/blob/main/LICENSE)
1. [jolpica-f1](https://github.com/jolpica/jolpica-f1/blob/main/docs/README.md)