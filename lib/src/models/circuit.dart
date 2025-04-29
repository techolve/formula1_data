import 'location.dart';

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

  factory Circuit.fromJson(Map<String, dynamic> json) {
    return Circuit(
      circuitId: json['circuitId'],
      url: json['url'],
      circuitName: json['circuitName'],
      location: Location.fromJson(json['Location']),
    );
  }

  @override
  String toString() {
    return 'Circuit(circuitId: $circuitId, url: $url, circuitName: $circuitName, location: $location)';
  }
}
