import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:t_store/appconfig.dart';

class UpdatePasswordService {
  static const String baseUrl = AppConfig.baseUrl;

  /// 🔹 Add New Password - verify code and update password
  static Future<http.Response> addNewPassword(
      String code, String newPassword) async {
    return await http.post(
      Uri.parse("$baseUrl/employee/add-new-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "code": code,
        "newPassword": newPassword,
      }),
    );
  }
}
