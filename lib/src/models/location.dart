class Location {
  final double latitude;
  final double longitude;
  final String locality;
  final String country;

  Location({
    required this.latitude,
    required this.longitude,
    required this.locality,
    required this.country,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: double.parse(json['lat']),
      longitude: double.parse(json['long']),
      locality: json['locality'],
      country: json['country'],
    );
  }

  @override
  String toString() {
    return 'Location(latitude: $latitude, longitude: $longitude, locality: $locality, country: $country)';
  }
}
