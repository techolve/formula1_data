class Driver {
  final String driverId;
  final String url;
  final String givenName;
  final String familyName;
  final DateTime dateOfBirth;
  final String nationality;

  Driver({
    required this.driverId,
    required this.url,
    required this.givenName,
    required this.familyName,
    required this.dateOfBirth,
    required this.nationality,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      driverId: json['driverId'],
      url: json['url'],
      givenName: json['givenName'],
      familyName: json['familyName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      nationality: json['nationality'],
    );
  }

  @override
  String toString() {
    return 'Driver(driverId: $driverId, url: $url, givenName: $givenName, familyName: $familyName, dateOfBirth: $dateOfBirth, nationality: $nationality)';
  }
}
