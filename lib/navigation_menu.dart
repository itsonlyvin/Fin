import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/features/app/screens/employee/attendance_history/attendance_history.dart';
import 'package:t_store/features/app/screens/employee/home/home.dart';
import 'package:t_store/features/app/screens/employee/notifications/notifications.dart';
import 'package:t_store/features/app/screens/employee/profile/profile.dart';
import 'package:t_store/features/app/screens/admin/home/home_admin.dart';
import 'package:t_store/features/app/screens/admin/employee/employee.dart';
import 'package:t_store/features/app/screens/admin/notifications/notifications_admin.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({
    super.key,
    this.admin = false,
  });

  final bool admin;

  @override
  Widget build(BuildContext context) {
    // Inject controller with proper config
    final controller = Get.put(NavigationController(admin: admin));
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
  late final List<Widget> screens;

  NavigationController({required bool admin}) {
    if (admin) {
      // Admin screens
      screens = [
        const HomePageAdmin(),
        const EmployeeAdmin(),
        const NotificationsAdmin(),
        const ProfileScreen(),
      ];
    } else {
      // Employee screens
      screens = [
        const HomePage(),
        const AttendanceHistory(),
        const Notifications(),
        const ProfileScreen(),
      ];
    }
  }
}
