import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/features/authentication/screens/onboarding/onboardging.dart';
import 'package:t_store/navigation_menu.dart';
import 'package:t_store/utils/theme/theme.dart';

void main() {
  // Register NavigationController globally when the app starts
  Get.put(NavigationController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      title: 'Fin',
      home: const Onboardging(),
      // 👆 Currently starting with Onboarding screen
      // If you want to start directly at the nav menu, use:
      // home: const NavigationMenu(),
    );
  }
}
