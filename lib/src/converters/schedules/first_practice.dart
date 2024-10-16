class FirstPractice {
  final DateTime dateTime;

  FirstPractice({required this.dateTime});

  factory FirstPractice.fromMap(dynamic map) {
    return FirstPractice(
      dateTime: DateTime.parse("${map["date"]} ${map["time"]}"),
    );
  }

  @override
  String toString() {
    return "FirstPractice(dateTime: $dateTime)";
  }
}
