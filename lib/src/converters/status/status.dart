class Status {
  final String statusId;
  final int count;
  final String status;

  const Status({
    required this.statusId,
    required this.count,
    required this.status,
  });

  factory Status.fromMap(dynamic map) {
    return Status(
      statusId: map["statusId"],
      count: int.parse(map["count"]),
      status: map["status"],
    );
  }

  @override
  String toString() {
    return "Status(statusId: $statusId, count: $count, status: $status)";
  }
}
