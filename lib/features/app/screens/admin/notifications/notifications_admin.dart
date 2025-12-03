import 'package:flutter/material.dart';
import 'package:openarms/utils/helpers/helper_functions.dart';
import 'package:openarms/utils/constants/colors.dart';

class NotificationsAdmin extends StatelessWidget {
  const NotificationsAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor:
          isDark ? const Color.fromARGB(255, 0, 0, 0) : TColors.white,
      body: Center(
        child: Text("Notifications"),
      ),
    );
  }
}
