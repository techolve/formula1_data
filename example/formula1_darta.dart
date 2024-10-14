import 'package:flutter/foundation.dart';
import 'package:formula1_data/src/api/results.dart';

void main() {
  final data = getResults();
  if (kDebugMode) {
    print(data);
  }
}
