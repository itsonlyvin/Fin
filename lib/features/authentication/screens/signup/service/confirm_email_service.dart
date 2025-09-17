import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:t_store/appconfig.dart';

class ApiService {
  static const String baseUrl = AppConfig.baseUrl;
  // 🔹 Replace with your LAN IP or 10.0.2.2 if emulator

  /// Verify Email
  static Future<http.Response> verifyEmail(String email, String code) async {
    return await http.post(
      Uri.parse("$baseUrl/employee/verify-email"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "code": code}),
    );
  }

  /// Resend Verification Code
  static Future<http.Response> resendVerification(String email) async {
    return await http.post(
      Uri.parse("$baseUrl/employee/resend-verification"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );
  }
}
