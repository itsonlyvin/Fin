import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/appbar/appbar.dart';
import 'package:t_store/common/widgets/images/t_circular_image.dart';
import 'package:t_store/features/app/screens/employee/profile/widgets/header.dart';
import 'package:t_store/features/app/screens/employee/profile/widgets/profile.dart';
import 'package:t_store/features/authentication/screens/onboarding/onboardging.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/employee_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout() {
    final storage = GetStorage();
    storage.erase(); // clear all saved login data
    Get.delete<EmployeeController>(); // remove controller from memory
    Get.offAll(() => const Onboardging()); // redirect to onboarding
  }

  @override
  Widget build(BuildContext context) {
    final empController = Get.find<EmployeeController>();

    return Scaffold(
      appBar: const TAppBar(
        showBackArrow: false,
        title: Text('Profile'),
      ),
      body: Obx(() {
        final details = empController.details;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                /// Profile Picture
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      const TCircularImage(
                        image: TImages.facebook,
                        width: 80,
                        height: 80,
                      ),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: const Text('Change Profile Picture'),
                      // ),
                    ],
                  ),
                ),

                const SizedBox(height: TSizes.spaceBtwItems / 2),
                const Divider(),

                /// Heading Personal Info
                const TSectionHeading(
                  title: 'Personal Information',
                  showActionButton: false,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                TProfileMenu(
                  onPressed: () {},
                  title: 'Name',
                  value: details['fullName'] ?? 'N/A',
                ),
                TProfileMenu(
                  onPressed: () {},
                  title: 'User ID',
                  value: empController.empId.value,
                  icon: Iconsax.copy,
                ),
                TProfileMenu(
                  onPressed: () {},
                  title: 'E-mail',
                  value: details['companyEmail'] ?? 'N/A',
                ),
                TProfileMenu(
                  onPressed: () {},
                  title: 'Phone Number',
                  value: details['phoneNumber'] ?? 'N/A',
                ),

                const Divider(),
                const SizedBox(height: TSizes.spaceBtwItems),

                /// Logout Button
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
