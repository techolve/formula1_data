import 'package:flutter_test/flutter_test.dart';

import 'package:formula1_data/formula1_data.dart';

void main() {
  test('get constructors data', () async {
    List<Constructor> constructors = await getConstructors(year: 2023);
    constructors.map(
      (Constructor constructor) {
        expect(constructor.constructorsId, "Red Bull");
      },
    );
  });
}
