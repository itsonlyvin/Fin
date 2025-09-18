import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:t_store/appconfig.dart';

class ForgetPasswordService {
  static const String baseUrl = AppConfig.baseUrl;

  /// Employee reset
  static Future<http.Response> sendEmployeeResetCode(String employeeId) async {
    return await http.post(
      Uri.parse("$baseUrl/employee/forget-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"employeeId": employeeId}),
    );
  }

  /// Admin reset
  static Future<http.Response> sendAdminResetCode(String adminId) async {
    return await http.post(
      Uri.parse("$baseUrl/admin/forget-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"adminId": adminId}),
    );
  }
}
