import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/features/app/screens/attendance_history/attendance_history.dart';
import 'package:t_store/features/app/screens/home/home.dart';
import 'package:t_store/features/app/screens/notifications/notifications.dart';
import 'package:t_store/features/app/screens/settings/settings.dart';

import 'package:t_store/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode ? Colors.black : Colors.white,
          indicatorColor: darkMode
              ? Colors.white.withAlpha((255 * 0.1).toInt())
              : Colors.black.withAlpha((0.1 * 255).toInt()),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Iconsax.home), label: 'Notifications'),
            NavigationDestination(
                icon: Icon(Iconsax.home), label: 'AttendanceHistory'),
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Settings'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomePage(),
    const Notifications(),
    const AttendanceHistory(),
    const Settings(),
  ];
}
