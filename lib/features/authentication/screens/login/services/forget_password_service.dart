import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:t_store/appconfig.dart';

class ForgetPasswordService {
  static const String baseUrl = AppConfig.baseUrl;

  /// 🔹 Send Forget Password Request
  static Future<http.Response> sendResetCode(String employeeId) async {
    return await http.post(
      Uri.parse("$baseUrl/employee/forget-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"employeeId": employeeId}),
    );
  }
}
