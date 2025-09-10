import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:t_store/common/widgets/login_signup/login_signup_divider.dart';
import 'package:t_store/features/authentication/screens/login/forgetpassword.dart';
import 'package:t_store/features/authentication/screens/onboarding/onboardging.dart';
import 'package:t_store/features/authentication/screens/signup/signup.dart';
import 'package:t_store/navigation_menu.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/text_strings.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // header sectiion

            TPrimaryHeaderContainer(
              child: Padding(
                padding: const EdgeInsets.all(
                  TSizes.spaceBtwSections,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        height: 150,
                        image: AssetImage(
                            dark ? TImages.lightAppLogo : TImages.darkAppLogo),
                      ),
                      // Text(
                      //   TTexts.loginTitle,
                      //   style: Theme.of(context).textTheme.headlineMedium,
                      // ),
                      // const SizedBox(height: TSizes.sm),
                      // Text(
                      //   TTexts.loginSubTitle,
                      //   style: Theme.of(context).textTheme.bodyMedium,
                      // ),
                      const SizedBox(height: TSizes.spaceBtwInputFields),
                    ],
                  ),
                ),
              ),
            ),

            //Form
            Padding(
              padding: const EdgeInsets.all(
                TSizes.spaceBtwSections,
              ),
              child: Form(
                child: Column(
                  children: [
                    // Header
                    Column(
                      children: [
                        Text(
                          TTexts.loginTitle,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
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

                    /// Password
                    TextFormField(
                      obscureText: isVisible ? false : true,
                      decoration: InputDecoration(
                        labelText: TTexts.password,
                        prefixIcon: const Icon(Iconsax.password_check),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields / 6),

                    // Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.to(() => const Forgetpassword()),
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
                      dividerText1: TTexts.orSignInWith,
                      dividerText2: TTexts.orGoBack,
                      isSecond: true,
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields / 6),

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
          ],
        ),
      ),
    );
  }
}
