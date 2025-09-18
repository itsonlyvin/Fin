import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/employee_controller.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:t_store/common/widgets/login_signup/login_signup_divider.dart';
import 'package:t_store/features/authentication/screens/login/forgetpassword.dart';
import 'package:t_store/features/authentication/screens/login/services/login_service.dart';
import 'package:t_store/features/authentication/screens/onboarding/onboardging.dart';
import 'package:t_store/features/authentication/screens/signup/signup.dart';
import 'package:t_store/navigation_menu.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/text_strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.logo,
    required this.color1,
    required this.color2,
    this.admin = false,
    required this.isfin,
  });
  final String logo;
  final Color color1;
  final Color color2;
  final bool admin;
  final bool isfin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isVisible = false;
  bool _loading = false;

  Future<void> _login() async {
    if (_employeeIdController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      Get.snackbar("Error", "Employee ID and Password required");
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await LoginService.login(
        _employeeIdController.text.trim(),
        _passwordController.text.trim(),
      );

      if (response.statusCode == 200) {
        final empId = _employeeIdController.text.trim();

        // Save in GetX controller (for current session)
        final empController = Get.put(EmployeeController());
        empController.setEmpId(empId);

        // Save in local storage (for persistence)
        final storage = GetStorage();
        storage.write("isLoggedIn", true);
        storage.write("isAdmin", widget.admin);
        storage.write("empId", empId);

        Get.snackbar("Success", response.body);

        // Navigate to home
        Get.offAll(() => NavigationMenu(admin: widget.admin));
      } else {
        Get.snackbar("Login Failed", response.body);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // header
            TPrimaryHeaderContainer(
              logo: widget.logo,
              color1: widget.color1,
              color2: widget.color2,
            ),

            Padding(
              padding: const EdgeInsets.all(TSizes.spaceBtwSections),
              child: Form(
                child: Column(
                  children: [
                    Text(
                      TTexts.loginTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Employee Id
                    TextFormField(
                      controller: _employeeIdController,
                      decoration: InputDecoration(
                        labelText:
                            widget.admin ? TTexts.adminId : TTexts.employeeId,
                        prefixIcon: const Icon(Iconsax.personalcard),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !isVisible,
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
                                isfin: widget.isfin,
                              )),
                          child: const Text(TTexts.forgetPassword),
                        ),
                      ],
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields / 6),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        child: _loading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(TTexts.signIn),
                      ),
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields * 1.8),

                    // Divider
                    const TFormDivider(
                      dividerText1: TTexts.orSignInWith,
                      dividerText2: TTexts.orGoBack,
                      isSecond: true,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Get.to(() => SignupScreen(
                                admin: widget.admin,
                                logo: widget.logo,
                                color1: widget.color1,
                                color2: widget.color2,
                                isfin: widget.isfin,
                              )),
                          child: const Text(TTexts.createAccount),
                        ),
                        TextButton(
                          onPressed: () => Get.to(() => const Onboardging()),
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
