import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/login_signup/login_signup_divider.dart';
import 'package:t_store/features/authentication/screens/signup/signup.dart';
import 'package:t_store/navigation_menu.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/spacing.dart';
import 'package:t_store/utils/constants/text_strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Header
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    TTexts.loginTitle,
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

                      /// Password
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: TTexts.password,
                          prefixIcon: Icon(Iconsax.password_check),
                          suffix: Icon(Iconsax.eye_slash),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwInputFields / 6),

                      // Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text(TTexts.forgetPassword),
                          ),
                        ],
                      ),

                      const SizedBox(height: TSizes.spaceBtwInputFields / 6),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Get.to(() => const NavigationMenu()),
                          child: const Text(TTexts.signIn),
                        ),
                      ),

                      const SizedBox(height: TSizes.spaceBtwInputFields * 1.8),

                      // Divider
                      const TFormDivider(
                        dividerText: TTexts.orSignUpWith,
                      ),

                      const SizedBox(height: TSizes.spaceBtwInputFields / 6),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => Get.to(
                              () => const SignupScreen(),
                            ),
                            child: const Text(TTexts.createAccount),
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
