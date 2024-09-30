class Driver {
  final String driverId;
  final int permanentNumber;
  final String code;
  final String url;
  final String givenName;
  final String familyName;
  final DateTime dateOfBirth;
  final String nationality;

  const Driver({
    required this.driverId,
    required this.permanentNumber,
    required this.code,
    required this.url,
    required this.givenName,
    required this.familyName,
    required this.dateOfBirth,
    required this.nationality,
  });

  factory Driver.fromMap(dynamic map) {
    return Driver(
      driverId: map["driverId"],
      permanentNumber: map["permanentNumber"],
      code: map["code"],
      url: map["url"],
      givenName: map["givenName"],
      familyName: map["familyName"],
      dateOfBirth: map["dateOfBirth"],
      nationality: map["nationality"],
    );
  }

  @override
  String toString() {
    return "Driver(driverId: $driverId, permanentNumber: $permanentNumber, code: $code, url: $url, givenName: $givenName, familyName: $dateOfBirth, dateOfBirth: $dateOfBirth, nationality: $nationality)";
  }
}
