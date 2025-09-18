import 'dart:convert';

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
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isVisible = false;
  bool _loading = false;

  /// 🔹 Login function
  Future<void> _login() async {
    if (_idController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      Get.snackbar("Error", "ID and Password are required");
      return;
    }

    setState(() => _loading = true);

    try {
      final response = widget.admin
          ? await LoginService.loginAdmin(
              _idController.text.trim(),
              _passwordController.text.trim(),
            )
          : await LoginService.loginEmployee(
              _idController.text.trim(),
              _passwordController.text.trim(),
            );

      if (response.statusCode == 200) {
        final empId = _idController.text.trim();
        final empController = Get.put(EmployeeController());

        // Save ID & flags
        empController.setEmpId(empId);
        empController.setIsFin(widget.isfin);
        if (widget.admin) empController.setAdminId(empId);

        final storage = GetStorage();
        storage.write("isLoggedIn", true);
        storage.write("isAdmin", widget.admin);
        storage.write("empId", empId);
        storage.write("isFin", widget.isfin);
        if (widget.admin) storage.write("adminId", empId);

        // ✅ Fetch details from backend
        final detailsResponse = widget.admin
            ? await LoginService.getAdminDetails(empId)
            : await LoginService.getEmployeeDetails(empId);

        if (detailsResponse.statusCode == 200) {
          final data = jsonDecode(detailsResponse.body);
          empController.setDetails(data); // save in GetX
          storage.write("details", data); // optional: persist
        }

        Get.snackbar("Success", response.body);
        Get.offAll(() => NavigationMenu(admin: widget.admin));
      } else {
        Get.snackbar("Login Failed", response.body);
      }
    } catch (e) {
      Get.snackbar("Error", "Server not reachable or error: $e");
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
            // Header
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
                    // Title
                    Text(
                      widget.admin ? "Admin Login" : TTexts.loginTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Employee/Admin ID
                    TextFormField(
                      controller: _idController,
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
                                admin: widget.admin,
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
