import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:openarms/common/widgets/appbar/appbar.dart';
import 'package:openarms/features/app/screens/employee/profile/widgets/header.dart';
import 'package:openarms/features/app/screens/employee/profile/widgets/profile.dart';
import 'package:openarms/features/authentication/screens/onboarding/onboardging.dart';
import 'package:openarms/utils/constants/colors.dart';
import 'package:openarms/utils/constants/sizes.dart';
import 'package:openarms/utils/employee_controller.dart';
import 'package:openarms/utils/helpers/helper_functions.dart';
import 'package:openarms/utils/navigation_menu.dart';
import 'package:openarms/features/app/screens/admin/home/backservice/employee_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout() {
    final storage = GetStorage();
    storage.erase();

    Get.delete<EmployeeController>();
    Get.delete<NavigationController>();

    Get.offAll(() => const Onboardging());
  }

  @override
  Widget build(BuildContext context) {
    final empController = Get.find<EmployeeController>();
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor:
          isDark ? const Color.fromARGB(255, 0, 0, 0) : TColors.white,
      appBar: const TAppBar(
        showBackArrow: false,
        title: Text('Profile'),
      ),
      body: Obx(() {
        final details = empController.details;
        final empId = empController.empId.value;

        /// Convert JSON -> Model
        final employee = Employee.fromJson({...details, "employeeId": empId});

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                const Divider(),
                const TSectionHeading(
                  title: 'Personal Information',
                  showActionButton: false,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                ///  Name
                TProfileMenu(
                  title: 'Name',
                  value: employee.fullName,
                  onPressed: () {},
                ),

                ///  ID
                TProfileMenu(
                  title: 'User ID',
                  value: employee.employeeId,
                  icon: Iconsax.copy,
                  onPressed: () {},
                ),

                ///  Email
                TProfileMenu(
                  title: 'Email',
                  value: employee.companyEmail,
                  onPressed: () {},
                ),

                ///  Phone
                TProfileMenu(
                  title: 'Phone',
                  value: employee.phoneNumber,
                  onPressed: () {},
                ),

                /// Salary
                TProfileMenu(
                  title: 'Salary',
                  value: "₹${employee.salary.toStringAsFixed(2)}",
                  onPressed: () {},
                ),

                /// Bonus
                TProfileMenu(
                  title: 'Bonus',
                  value: "₹${employee.bonus.toStringAsFixed(2)}",
                  onPressed: () {},
                ),

                const SizedBox(height: TSizes.spaceBtwSections),

                const Divider(),

                /// LOGOUT
                const SizedBox(height: TSizes.spaceBtwItems),
                Center(
                  child: TextButton(
                    onPressed: _logout,
                    child: const Text(
                      'Log Out',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
