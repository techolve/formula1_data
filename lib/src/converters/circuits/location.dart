class Location {
  final String lat;
  final String long;
  final String locality;
  final String country;

  Location({
    required this.lat,
    required this.long,
    required this.locality,
    required this.country,
  });

  factory Location.fromMap(dynamic map) {
    return Location(
      lat: map["lat"],
      long: map["long"],
      locality: map["locality"],
      country: map["country"],
    );
  }

  @override
  String toString() {
    return "Location(lat: $lat, long: $long, locality: $locality, country: $country)";
  }
}
