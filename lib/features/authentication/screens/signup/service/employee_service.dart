import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:t_store/appconfig.dart';

class AuthService {
  static const String baseUrl = AppConfig.baseUrl;

  /// Register Employee
  static Future<Map<String, dynamic>> registerEmployee({
    required String employeeId,
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required bool finOpenArms,
  }) async {
    final url = Uri.parse("$baseUrl/employee");

    final body = jsonEncode({
      "employeeId": employeeId,
      "fullName": fullName,
      "companyEmail": email,
      "phoneNumber": phone,
      "password": password,
      "finOrOpenArms": finOpenArms,
    });

    return _sendRequest(url, body);
  }

  /// Register Admin
  static Future<Map<String, dynamic>> registerAdmin({
    required String adminId,
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/admin");

    final body = jsonEncode({
      "adminId": adminId,
      "fullName": fullName,
      "companyEmail": email,
      "phoneNumber": phone,
      "password": password,
    });

    return _sendRequest(url, body);
  }

  /// Common POST request handler
  static Future<Map<String, dynamic>> _sendRequest(Uri url, String body) async {
    final headers = {"Content-Type": "application/json"};

    try {
      final response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 201) {
        return {"success": true, "message": "Registered successfully"};
      } else {
        String backendMessage;
        try {
          final decoded = jsonDecode(response.body);
          backendMessage =
              decoded['message'] ?? response.reasonPhrase ?? "Unknown error";
        } catch (_) {
          backendMessage = response.body.isNotEmpty
              ? response.body
              : response.reasonPhrase ?? "Unknown error";
        }

        return {"success": false, "message": backendMessage};
      }
    } catch (e) {
      return {"success": false, "message": "Exception: $e"};
    }
  }
}
