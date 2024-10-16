import 'package:formula1_data/src/converters/circuits/location.dart';

class Circuit {
  final String circuitId;
  final String url;
  final String circuitName;
  final Location location;

  Circuit({
    required this.circuitId,
    required this.url,
    required this.circuitName,
    required this.location,
  });

  factory Circuit.fromMap(dynamic map) {
    return Circuit(
      circuitId: map["circuitId"],
      url: map["url"],
      circuitName: map["circuitName"],
      location: Location.fromMap(map["Location"]),
    );
  }

  @override
  String toString() {
    return "Circuit(circuitId: $circuitId, url: $url, circuitName: $circuitName, location: $location)";
  }
}
