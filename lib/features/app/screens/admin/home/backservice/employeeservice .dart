import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:t_store/appconfig.dart';
import 'package:t_store/features/app/screens/admin/home/backservice/DailyAttendance.dart';
import 'employee_model.dart';

class EmployeeService {
  Future<List<Employee>> fetchEmployees(String company) async {
    // Map the company name to the right endpoint
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

  Future<List<DailyAttendance>> fetchMonthlyAttendance(
      String employeeId, int year, int month) async {
    final url = Uri.parse(
        "${AppConfig.baseUrl}/api/attendance/admin/monthly-attendance?employeeId=$employeeId&year=$year&month=$month");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => DailyAttendance.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load monthly attendance");
    }
  }
}
