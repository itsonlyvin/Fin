import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:t_store/employee_controller.dart';
import 'package:t_store/features/authentication/screens/onboarding/onboardging.dart';
import 'package:t_store/navigation_menu.dart';
import 'package:t_store/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // ✅ initialize storage
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    final bool isLoggedIn = storage.read("isLoggedIn") ?? false;
    final bool isAdmin = storage.read("isAdmin") ?? false;
    final String? empId = storage.read("empId");

    // If logged in before, set it again in EmployeeController
    if (isLoggedIn && empId != null) {
      final empController = Get.put(EmployeeController());
      empController.setEmpId(empId);
    }

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
