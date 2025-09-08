import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/features/app/screens/home/home.dart';
import 'package:t_store/navigation_menu.dart';

import 'package:t_store/utils/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // This is the main entry point of the application.
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        title: 'Base Code',
        // The home widget is the main screen of the application.
        home: const NavigationMenu());
  }
}
