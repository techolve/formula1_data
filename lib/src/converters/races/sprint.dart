class Sprint {
  final DateTime dateTime;

  Sprint({required this.dateTime});

  factory Sprint.fromMap(dynamic map) {
    return Sprint(
      dateTime: DateTime.parse("${map["date"]} ${map["time"]}"),
    );
  }

  @override
  String toString() {
    return "SecondPractice(dateTime: $dateTime)";
  }
}
