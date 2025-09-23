class DailyAttendance {
  final int day;
  final String status;

  DailyAttendance({
    required this.day,
    required this.status,
  });

  factory DailyAttendance.fromJson(Map<String, dynamic> json) {
    // If backend sends a "day" directly, use it
    if (json.containsKey('day')) {
      return DailyAttendance(
        day: json['day'] ?? 0,
        status: json['status'] ?? "No Data",
      );
    }

    // If backend sends a full date instead of day
    if (json.containsKey('date')) {
      DateTime parsedDate = DateTime.parse(json['date']);
      return DailyAttendance(
        day: parsedDate.day,
        status: json['status'] ?? "No Data",
      );
    }

    // Fallback
    return DailyAttendance(
      day: 0,
      status: "No Data",
    );
  }
}
