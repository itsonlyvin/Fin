import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:t_store/appconfig.dart';

class LoginService {
  static const String baseUrl = AppConfig.baseUrl;

  /// Employee login
  static Future<http.Response> loginEmployee(
      String employeeId, String password) async {
    return await http.put(
      Uri.parse("$baseUrl/employee/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "employeeId": employeeId,
        "password": password,
      }),
    );
  }

  /// Admin login
  static Future<http.Response> loginAdmin(
      String adminId, String password) async {
    return await http.put(
      Uri.parse("$baseUrl/admin/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "adminId": adminId,
        "password": password,
      }),
    );
  }

  /// 🔹 Get employee details
  static Future<http.Response> getEmployeeDetails(String employeeId) async {
    return await http.get(
      Uri.parse("$baseUrl/employee/$employeeId"),
      headers: {"Content-Type": "application/json"},
    );
  }

  /// 🔹 Get admin details
  static Future<http.Response> getAdminDetails(String adminId) async {
    return await http.get(
      Uri.parse("$baseUrl/admin/$adminId"),
      headers: {"Content-Type": "application/json"},
    );
  }
}
