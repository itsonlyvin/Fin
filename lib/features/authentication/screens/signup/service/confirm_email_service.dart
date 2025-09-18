import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:t_store/appconfig.dart';

class ApiService {
  static const String baseUrl = AppConfig.baseUrl;

  /// Employee Email Verification
  static Future<http.Response> verifyEmployeeEmail(
      String email, String code) async {
    return await http.post(
      Uri.parse("$baseUrl/employee/verify-email"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "code": code}),
    );
  }

  static Future<http.Response> resendEmployeeVerification(String email) async {
    return await http.post(
      Uri.parse("$baseUrl/employee/resend-verification"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );
  }

  /// Admin Email Verification
  static Future<http.Response> verifyAdminEmail(
      String email, String code) async {
    return await http.post(
      Uri.parse("$baseUrl/admin/verify-email"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "code": code}),
    );
  }

  static Future<http.Response> resendAdminVerification(String email) async {
    return await http.post(
      Uri.parse("$baseUrl/admin/resend-verification"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );
  }
}
