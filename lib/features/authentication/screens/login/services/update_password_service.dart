import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:t_store/appconfig.dart';

class UpdatePasswordService {
  static const String baseUrl = AppConfig.baseUrl;

  /// Employee new password
  static Future<http.Response> addEmployeeNewPassword(
      String code, String newPassword) async {
    return await http.post(
      Uri.parse("$baseUrl/employee/add-new-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"code": code, "newPassword": newPassword}),
    );
  }

  /// Admin new password
  static Future<http.Response> addAdminNewPassword(
      String code, String newPassword) async {
    return await http.post(
      Uri.parse("$baseUrl/admin/add-new-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"code": code, "newPassword": newPassword}),
    );
  }
}
