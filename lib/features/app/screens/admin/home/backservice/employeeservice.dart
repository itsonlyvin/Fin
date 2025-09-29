import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:t_store/appconfig.dart';
import 'package:t_store/features/app/screens/admin/home/backservice/attendance_report.dart';
import 'daily_attendance.dart';
import 'employee_model.dart';

class EmployeeService {
  // Fetch employees based on company
  Future<List<Employee>> fetchEmployees(String company) async {
    String endpoint = company == "Fin"
        ? "${AppConfig.baseUrl}/employee/all_employees_fin"
        : "${AppConfig.baseUrl}/employee/all_employees_openarms";

    final response = await http.get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Employee.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load employees");
    }
  }

  // Fetch monthly attendance
  Future<List<DailyAttendance>> fetchMonthlyAttendance(
      String employeeId, int year, int month) async {
    final url = Uri.parse(
        "${AppConfig.baseUrl}/api/attendance/admin/monthly-attendance?employeeId=$employeeId&year=$year&month=$month");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      List<dynamic> body;

      // Handle {"days": [...]} or plain list []
      if (decoded is Map && decoded.containsKey('days')) {
        body = decoded['days'];
      } else if (decoded is List) {
        body = decoded;
      } else {
        throw Exception("Unexpected response format");
      }

      return body.map((e) => DailyAttendance.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load monthly attendance");
    }
  }

  // Admin override
  Future<void> adminOverride({
    required String employeeId,
    required int year,
    required int month,
    required int day,
    required bool allowOvertime,
    required bool isPresent,
    required bool halfDay,
    String? remarks,
  }) async {
    final url = Uri.parse(
      "${AppConfig.baseUrl}/api/attendance/admin/override"
      "?employeeId=$employeeId&year=$year&month=$month&day=$day"
      "&allowOvertime=$allowOvertime&isPresent=$isPresent&halfDay=$halfDay"
      "${remarks != null ? '&remarks=$remarks' : ''}",
    );

    final response = await http.post(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to override attendance");
    }
  }

  // Fetch a single employee by ID
  Future<Employee> fetchEmployeeById(String employeeId) async {
    final response =
        await http.get(Uri.parse("${AppConfig.baseUrl}/employee/$employeeId"));

    if (response.statusCode == 200) {
      return Employee.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load employee details");
    }
  }

  // Update salary
  Future<void> updateSalary(String employeeId, double salary) async {
    final response = await http.put(
      Uri.parse("${AppConfig.baseUrl}/employee/salary"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "employeeId": employeeId,
        "salary": salary.toString(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update salary: ${response.body}");
    }
  }

  // Update bonus
  Future<void> updateBonus(String employeeId, double bonus) async {
    final response = await http.put(
      Uri.parse("${AppConfig.baseUrl}/employee/bonus"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "employeeId": employeeId,
        "bonus": bonus.toString(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update bonus: ${response.body}");
    }
  }

  Future<AttendanceReport> fetchMonthlyReport(
      String employeeId, int year, int month) async {
    final url = Uri.parse(
        "${AppConfig.baseUrl}/api/attendance/report/$employeeId?year=$year&month=$month");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return AttendanceReport.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch monthly report");
    }
  }
}
