class Qualifying {
  final DateTime dateTime;

  Qualifying({required this.dateTime});

  factory Qualifying.fromMap(dynamic map) {
    return Qualifying(
      dateTime: DateTime.parse("${map["date"]} ${map["time"]}"),
    );
  }

  @override
  String toString() {
    return "Qualifying(dateTime: $dateTime)";
  }
}
