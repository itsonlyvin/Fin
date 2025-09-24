class DailyAttendance {
  final int day;
  final DateTime date;
  final String status;
  final DateTime? clockIn;
  final DateTime? clockOut;
  final double? totalHours;
  final String? adminRemarks;
  final bool? overtimeEnabled;

  DailyAttendance({
    required this.day,
    required this.date,
    required this.status,
    this.clockIn,
    this.clockOut,
    this.totalHours,
    this.adminRemarks,
    this.overtimeEnabled,
  });

  factory DailyAttendance.fromJson(Map<String, dynamic> json) {
    // Parse date
    DateTime parsedDate = json.containsKey('date')
        ? DateTime.parse(json['date'])
        : DateTime.now();

    // Parse day safely
    int parsedDay = 0;
    if (json.containsKey('day')) {
      if (json['day'] is int) {
        parsedDay = json['day'];
      } else {
        parsedDay = int.tryParse(json['day'].toString()) ?? parsedDate.day;
      }
    } else {
      parsedDay = parsedDate.day;
    }

    return DailyAttendance(
      day: parsedDay,
      date: parsedDate,
      status: json['status'] ?? "No Data",
      clockIn: json['clockIn'] != null ? DateTime.parse(json['clockIn']) : null,
      clockOut:
          json['clockOut'] != null ? DateTime.parse(json['clockOut']) : null,
      totalHours: json['totalHours'] != null
          ? double.tryParse(json['totalHours'].toString())
          : null,
      adminRemarks: json['adminRemarks'],
      overtimeEnabled: json['overtimeEnabled'],
    );
  }
}
