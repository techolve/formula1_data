class ThirdPractice {
  final DateTime dateTime;

  ThirdPractice({required this.dateTime});

  factory ThirdPractice.fromMap(dynamic map) {
    return ThirdPractice(
      dateTime: DateTime.parse("${map["date"]} ${map["time"]}"),
    );
  }

  @override
  String toString() {
    return "ThirdPractice(dateTime: $dateTime)";
  }
}
