import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:t_store/appconfig.dart';

class LoginService {
  static const String baseUrl = AppConfig.baseUrl;

  /// 🔹 Login Employee
  static Future<http.Response> login(String employeeId, String password) async {
    return await http.put(
      Uri.parse("$baseUrl/employee/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "employeeId": employeeId,
        "password": password,
      }),
    );
  }
}
