import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/features/app/screens/attendance_history/attendance_history.dart';
import 'package:t_store/features/app/screens/home/home.dart';
import 'package:t_store/features/app/screens/notifications/notifications.dart';
import 'package:t_store/features/app/screens/settings/profile.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Use existing controller (created in main.dart or bindings)
    final controller = Get.find<NavigationController>();
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: !darkMode
              ? const Color.fromARGB(255, 227, 222, 222)
                  .withAlpha((255 * 0.1).toInt())
              : Colors.black.withAlpha((0.1 * 255).toInt()),
          indicatorColor: darkMode
              ? Colors.white.withAlpha((255 * 0.1).toInt())
              : Colors.black.withAlpha((0.1 * 255).toInt()),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Iconsax.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.document),
              label: 'Attendance',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.notification),
              label: 'Notifications',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.user),
              label: 'Profile',
            ),
          ],
        ),
      ),

      // Keep screens alive using IndexedStack
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: controller.screens,
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = const [
    HomePage(),
    AttendanceHistory(),
    Notifications(),
    ProfileScreen(),
  ];
}
