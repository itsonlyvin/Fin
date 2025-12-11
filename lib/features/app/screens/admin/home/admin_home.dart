import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openarms/utils/employee_controller.dart';
import 'package:openarms/features/app/screens/admin/home/employee/employee_list.dart';
import 'package:openarms/features/app/screens/employee/attendance_history/widgets/specialColumn.dart';
import 'package:openarms/utils/constants/image_strings.dart';
import 'package:openarms/utils/constants/sizes.dart';
import 'package:openarms/utils/helpers/helper_functions.dart';
import 'package:openarms/utils/constants/colors.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    final empController = Get.find<EmployeeController>();

    return Scaffold(
      backgroundColor:
          dark ? const Color.fromARGB(255, 0, 0, 0) : TColors.white,
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
                        "Welcome ${empController.adminId.value}",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      //  const Icon(Iconsax.notification, size: 28),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const EmployeeList(
                          company: 'Fin',
                        )),
                    child: SpecialColumn(
                      dark: dark,
                      child: Image(
                        height: 150,
                        image: AssetImage(
                          dark ? TImages.finDarkLogo : TImages.finLightLogo,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const EmployeeList(
                          company: 'OpenArms',
                        )),
                    child: SpecialColumn(
                      dark: dark,
                      child: Image(
                        height: 150,
                        image: AssetImage(
                          dark ? TImages.openDarkLogo : TImages.openLightLogo,
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
