import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:t_store/features/authentication/screens/login/login.dart';
import 'package:t_store/features/authentication/screens/onboarding/onboardging.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/text_strings.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';
import 'package:t_store/common/widgets/login_signup/login_signup_divider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Column(
        children: [
          // Header
          TPrimaryHeaderContainer(
            child: Padding(
              padding: const EdgeInsets.all(TSizes.spaceBtwSections),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      height: 150,
                      image: AssetImage(
                        dark ? TImages.lightAppLogo : TImages.darkAppLogo,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                  ],
                ),
              ),
            ),
          ),

          // ✅ Make form scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(TSizes.spaceBtwSections),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header text
                    Text(
                      TTexts.signupTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

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

                    // Phone
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: TTexts.phoneNo,
                        prefixIcon: Icon(Iconsax.mobile),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Password
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: TTexts.password,
                        prefixIcon: Icon(Iconsax.password_check),
                        suffix: Icon(Iconsax.eye_slash),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Create Account button
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
                      dividerText1: TTexts.orSignUpWith,
                      dividerText2: TTexts.orGoBack,
                      isSecond: true,
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields / 6),

                    // Sign in link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Get.to(
                            () => const SignupScreen(),
                          ),
                          child: const Text(TTexts.createAccount),
                        ),
                        TextButton(
                          onPressed: () => Get.to(
                            () => const Onboardging(),
                          ),
                          child: const Text(TTexts.home),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
