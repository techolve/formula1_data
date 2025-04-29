/// Represents the status of a race result in Formula 1.
///
/// This class contains information about the final status of a driver's race,
/// including the status ID, count of occurrences, and a description of the status.
class Status {
  /// The unique identifier for this status.
  final int statusId;

  /// The number of times this status occurred in the race.
  final int count;

  /// A description of the status (e.g., "Finished", "Accident", "Retired").
  final String status;

  /// Creates a new [Status] instance.
  ///
  /// [statusId] is the unique identifier for this status.
  /// [count] is the number of times this status occurred.
  /// [status] is a description of the status.
  Status({
    required this.statusId,
    required this.count,
    required this.status,
  });

  /// Creates a [Status] instance from a JSON object.
  ///
  /// The JSON object should contain the following fields:
  /// - 'statusId': A string representing the status ID
  /// - 'count': A string representing the count
  /// - 'status': A string describing the status
  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      statusId: int.parse(json['statusId']),
      count: int.parse(json['count']),
      status: json['status'],
    );
  }

  @override
  String toString() {
    return 'Status(statusId: $statusId, count: $count, status: $status)';
  }
}
