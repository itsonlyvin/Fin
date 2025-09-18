import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/employee_controller.dart';
import 'package:t_store/features/app/screens/admin/home/pages/adminpagecontroller.dart';
import 'package:t_store/features/app/screens/admin/home/pages/home_attendance.dart';
import 'package:t_store/features/app/screens/employee/attendance_history/widgets/specialColumn.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/text_strings.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    // final controller = Get.find<AdminPageController>();
    final empController = Get.find<EmployeeController>();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: TSizes.sm,
                left: TSizes.defaultSpace,
                right: TSizes.defaultSpace,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Welcome 👋 ${empController.adminId.value}",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      //  const Icon(Iconsax.notification, size: 28),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const HomePageAttendance(
                          companyName: TTexts.companyName,
                        )),
                    child: SpecialColumn(
                      dark: dark,
                      child: Image(
                        height: 150,
                        image: AssetImage(
                          dark
                              ? TImages.finDarkAppLogo
                              : TImages.finLightAppLogo,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const HomePageAttendance(
                          companyName: TTexts.companyName1,
                        )),
                    child: SpecialColumn(
                      dark: dark,
                      child: Image(
                        height: 150,
                        image: AssetImage(
                          dark
                              ? TImages.openDarkAppLogo
                              : TImages.openLightAppLogo,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
