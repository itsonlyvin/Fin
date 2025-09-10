import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:t_store/common/widgets/login_signup/login_signup_divider.dart';
import 'package:t_store/features/authentication/screens/onboarding/onboardging.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/text_strings.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

class Forgetpassword extends StatelessWidget {
  const Forgetpassword({super.key});

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
                          TTexts.forgetPassword,
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

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(TTexts.sendEmail),
                      ),
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields * 1.8),

                    // Divider
                    const TFormDivider(
                      dividerText1: TTexts.orGoBack,
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields / 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
