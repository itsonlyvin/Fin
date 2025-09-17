import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:t_store/common/widgets/login_signup/login_signup_divider.dart';
import 'package:t_store/features/authentication/screens/login/forgetpassword.dart';
import 'package:t_store/features/authentication/screens/onboarding/onboardging.dart';
import 'package:t_store/features/authentication/screens/signup/signup.dart';
import 'package:t_store/navigation_menu.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/text_strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen(
      {super.key,
      required this.logo,
      required this.color1,
      required this.color2,
      this.admin = false,
      required this.isfin});
  final String logo;
  final Color color1;
  final Color color2;
  final bool admin;
  final bool isfin;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // header sectiion

            TPrimaryHeaderContainer(
              logo: widget.logo,
              color1: widget.color1,
              color2: widget.color2,
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
                      decoration: InputDecoration(
                        labelText:
                            widget.admin ? TTexts.adminId : TTexts.employeeId,
                        prefixIcon: const Icon(Iconsax.personalcard),
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
                          onPressed: () => Get.to(() => Forgetpassword(
                                logo: widget.logo,
                                color1: widget.color1,
                                color2: widget.color2,
                              )),
                          child: const Text(TTexts.forgetPassword),
                        ),
                      ],
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields / 6),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.to(
                          () => NavigationMenu(
                            admin: widget.admin ? true : false,
                          ),
                        ),
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
                            () => SignupScreen(
                              admin: widget.admin ? true : false,
                              logo: widget.logo,
                              color1: widget.color1,
                              color2: widget.color2,
                              isfin: widget.isfin,
                            ),
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
