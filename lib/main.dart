import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:t_store/employee_controller.dart';
import 'package:t_store/features/authentication/screens/onboarding/onboardging.dart';
import 'package:t_store/navigation_menu.dart';
import 'package:t_store/utils/theme/theme.dart';
import 'package:t_store/features/authentication/screens/login/services/login_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> _restoreUserSession(bool isLoggedIn, bool isAdmin, String? empId,
      bool isFin, String? adminId) async {
    if (isLoggedIn && empId != null) {
      final empController = Get.put(EmployeeController(), permanent: true);
      empController.setEmpId(empId);
      empController.setIsFin(isFin);
      if (isAdmin && adminId != null) empController.setAdminId(adminId);

      // 🔹 Try to fetch details from backend
      try {
        final response = isAdmin
            ? await LoginService.getAdminDetails(empId)
            : await LoginService.getEmployeeDetails(empId);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          empController.setDetails(data);

          // Store details in GetStorage too (optional)
          final storage = GetStorage();
          storage.write("details", data);
        }
      } catch (e) {
        debugPrint("Failed to fetch user details on restore: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    final bool isLoggedIn = storage.read("isLoggedIn") ?? false;
    final bool isAdmin = storage.read("isAdmin") ?? false;
    final String? empId = storage.read("empId");
    final bool isFin = storage.read("isFin") ?? false;
    final String? adminId = storage.read("adminId");

    // Restore session
    _restoreUserSession(isLoggedIn, isAdmin, empId, isFin, adminId);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      title: 'Fin',
      home: isLoggedIn ? NavigationMenu(admin: isAdmin) : const Onboardging(),
    );
  }
}
