import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/login_signup/login_signup_divider.dart';
import 'package:t_store/features/authentication/screens/login/login.dart';
import 'package:t_store/navigation_menu.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/spacing.dart';
import 'package:t_store/utils/constants/text_strings.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              // Header
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    TTexts.signupTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              //Form
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: TSizes.spaceBtwSections,
                  ),
                  child: Column(
                    children: [
                      // Employee Id
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: TTexts.employeeId,
                          prefixIcon: Icon(Iconsax.personalcard),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      // Name
                      TextFormField(
                        expands: false,
                        decoration: const InputDecoration(
                          labelText: TTexts.name,
                          prefixIcon: Icon(Iconsax.user),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      // Email
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: TTexts.email,
                          prefixIcon: Icon(Iconsax.direct_right),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      //
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: TTexts.phoneNo,
                          prefixIcon: Icon(Iconsax.mobile),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      /// Password
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: TTexts.password,
                          prefixIcon: Icon(Iconsax.password_check),
                          suffix: Icon(Iconsax.eye_slash),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      const SizedBox(height: TSizes.spaceBtwInputFields),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Get.to(() => const LoginScreen()),
                          child: const Text(TTexts.createAccount),
                        ),
                      ),

                      const SizedBox(height: TSizes.spaceBtwInputFields * 1.8),

                      // Divider
                      const TFormDivider(
                        dividerText: TTexts.orSignInWith,
                      ),

                      const SizedBox(height: TSizes.spaceBtwInputFields / 6),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => Get.to(
                              () => const LoginScreen(),
                            ),
                            child: const Text(TTexts.signIn),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
