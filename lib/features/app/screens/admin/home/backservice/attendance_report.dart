import 'package:openarms/features/app/screens/admin/home/backservice/daily_attendance.dart';

/// Model for monthly attendance report
class AttendanceReport {
  final String employeeId;
  final String employeeName;
  final int month;
  final int year;
  final int totalDays;
  final int daysLeft;
  final int presentDays;
  final int halfDays;
  final int absentDays;
  final int noClockOutDays;
  final int paidLeave;
  final int holidayCount;
  final double totalHoursWorked;
  final double salaryEarned;
  final double bonusEarned;
  final double totalOvertimeHours;
  final double overtimePay;
  final List<DailyAttendance> dailyAttendance;

  AttendanceReport({
    required this.employeeId,
    required this.employeeName,
    required this.month,
    required this.year,
    required this.totalDays,
    required this.daysLeft,
    required this.presentDays,
    required this.halfDays,
    required this.absentDays,
    required this.noClockOutDays,
    required this.paidLeave,
    required this.holidayCount,
    required this.totalHoursWorked,
    required this.salaryEarned,
    required this.bonusEarned,
    required this.totalOvertimeHours,
    required this.overtimePay,
    required this.dailyAttendance,
  });

  factory AttendanceReport.fromJson(Map<String, dynamic> json) {
    return AttendanceReport(
      employeeId: json['employeeId'] ?? '',
      employeeName: json['employeeName'] ?? '',
      month: json['month'] ?? 0,
      year: json['year'] ?? 0,
      totalDays: json['totalDays'] ?? 0,
      daysLeft: json['daysLeft'] ?? 0,
      presentDays: json['presentDays'] ?? 0,
      halfDays: json['halfDays'] ?? 0,
      absentDays: json['absentDays'] ?? 0,
      noClockOutDays: json['noClockOutDays'] ?? 0,
      paidLeave: json['paidLeave'] ?? 0,
      holidayCount: json['holidayCount'] ?? 0,
      totalHoursWorked: (json['totalHoursWorked'] ?? 0).toDouble(),
      salaryEarned: (json['salaryEarned'] ?? 0).toDouble(),
      bonusEarned: (json['bonusEarned'] ?? 0).toDouble(),
      totalOvertimeHours: (json['totalOvertimeHours'] ?? 0).toDouble(),
      overtimePay: (json['overtimePay'] ?? 0).toDouble(),
      dailyAttendance: (json['dailyAttendance'] as List? ?? [])
          .map((e) => DailyAttendance.fromJson(e))
          .toList(),
    );
  }
}
