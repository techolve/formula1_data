class SecondPractice {
  final DateTime dateTime;

  SecondPractice({required this.dateTime});

  factory SecondPractice.fromMap(dynamic map) {
    return SecondPractice(
      dateTime: DateTime.parse("${map["date"]} ${map["time"]}"),
    );
  }

  @override
  String toString() {
    return "SecondPractice(dateTime: $dateTime)";
  }
}
