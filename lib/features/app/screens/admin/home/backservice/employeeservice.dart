import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:t_store/utils/appconfig.dart';
import 'package:t_store/features/app/screens/admin/home/backservice/attendance_report.dart';
import 'daily_attendance.dart';
import 'employee_model.dart';

class EmployeeService {
  final String baseUrl = AppConfig.baseUrl;

  /// Fetch all employees based on company type
  Future<List<Employee>> fetchEmployees(String company) async {
    final endpoint = company == "Fin"
        ? "$baseUrl/employee/all_employees_fin"
        : "$baseUrl/employee/all_employees_openarms";

    final response = await http.get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Employee.fromJson(e)).toList();
    } else {
      throw Exception(
          "Failed to load employees: ${response.statusCode} ${response.body}");
    }
  }

  /// Fetch monthly attendance for a given employee
  Future<List<DailyAttendance>> fetchMonthlyAttendance(
      String employeeId, int year, int month) async {
    final uri = Uri.parse("$baseUrl/api/attendance/admin/monthly-attendance")
        .replace(queryParameters: {
      "employeeId": employeeId,
      "year": year.toString(),
      "month": month.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      List<dynamic> body;

      // Handle response with { "days": [...] } or plain list []
      if (decoded is Map && decoded.containsKey('days')) {
        body = decoded['days'];
      } else if (decoded is List) {
        body = decoded;
      } else {
        throw Exception("Unexpected response format: $decoded");
      }

      return body.map((e) => DailyAttendance.fromJson(e)).toList();
    } else {
      throw Exception(
          "Failed to load monthly attendance: ${response.statusCode} ${response.body}");
    }
  }

  /// Admin override attendance for a specific day
  Future<void> adminOverride({
    required String employeeId,
    required int year,
    required int month,
    required int day,
    required bool allowOvertime,
    required bool isPresent,
    required bool halfDay,
    String? remarks,
    String? clockIn,
    String? clockOut,
  }) async {
    final params = {
      "employeeId": employeeId,
      "year": year.toString(),
      "month": month.toString(),
      "day": day.toString(),
      "allowOvertime": allowOvertime.toString(),
      "isPresent": isPresent.toString(),
      "halfDay": halfDay.toString(),
      if (remarks != null) "remarks": remarks,
      if (clockIn != null) "clockIn": clockIn,
      if (clockOut != null) "clockOut": clockOut,
    };

    final uri = Uri.parse("$baseUrl/api/attendance/admin/override")
        .replace(queryParameters: params);

    final response = await http.post(uri);

    if (response.statusCode != 200) {
      throw Exception(
          "Failed to override attendance: ${response.statusCode} ${response.body}");
    }
  }

  /// Fetch a single employee by ID
  Future<Employee> fetchEmployeeById(String employeeId) async {
    final response = await http.get(Uri.parse("$baseUrl/employee/$employeeId"));

    if (response.statusCode == 200) {
      return Employee.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          "Failed to load employee details: ${response.statusCode} ${response.body}");
    }
  }

  /// Update employee salary
  Future<void> updateSalary(String employeeId, double salary) async {
    final url = Uri.parse("$baseUrl/employee/salary");

    final body = jsonEncode({
      "employeeId": employeeId,
      "salary": salary.toString(),
    });

    final response = await http.put(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode != 200) {
      throw Exception(
          "Failed to update salary: ${response.statusCode} ${response.body}");
    }
  }

  /// Update employee bonus
  Future<void> updateBonus(String employeeId, double bonus) async {
    final url = Uri.parse("$baseUrl/employee/bonus");

    final body = jsonEncode({
      "employeeId": employeeId,
      "bonus": bonus.toString(),
    });

    final response = await http.put(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode != 200) {
      throw Exception(
          "Failed to update bonus: ${response.statusCode} ${response.body}");
    }
  }

  /// Fetch monthly attendance report for a given employee
  Future<AttendanceReport> fetchMonthlyReport(
      String employeeId, int year, int month) async {
    final uri = Uri.parse("$baseUrl/api/attendance/report/$employeeId")
        .replace(queryParameters: {
      "year": year.toString(),
      "month": month.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return AttendanceReport.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          "Failed to fetch monthly report: ${response.statusCode} ${response.body}");
    }
  }
}
