import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:t_store/common/widgets/login_signup/login_signup_divider.dart';
import 'package:t_store/features/authentication/screens/login/login.dart';
import 'package:t_store/features/authentication/screens/login/services/update_password_service.dart';
import 'package:t_store/features/authentication/screens/onboarding/onboardging.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/text_strings.dart';

class Updatepassword extends StatefulWidget {
  const Updatepassword({
    super.key,
    required this.logo,
    required this.color1,
    required this.color2,
    required this.isfin,
  });

  final String logo;
  final Color color1;
  final Color color2;
  final bool isfin;

  @override
  State<Updatepassword> createState() => _UpdatepasswordState();
}

class _UpdatepasswordState extends State<Updatepassword> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  bool _isVisible = false;

  Future<void> _updatePassword() async {
    if (_codeController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Code and Password are required",
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await UpdatePasswordService.addNewPassword(
        _codeController.text.trim(),
        _passwordController.text.trim(),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          response.body,
        );

        // Navigate to login page
        Get.off(() => LoginScreen(
              logo: widget.logo,
              color1: widget.color1,
              color2: widget.color2,
              isfin: widget.isfin,
            ));
      } else {
        Get.snackbar(
          "Failed",
          response.body,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
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
            // header section
            TPrimaryHeaderContainer(
              logo: widget.logo,
              color1: widget.color1,
              color2: widget.color2,
            ),

            // form
            Padding(
              padding: const EdgeInsets.all(TSizes.spaceBtwSections),
              child: Form(
                child: Column(
                  children: [
                    Text(
                      "Update Password",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Code input
                    TextFormField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        labelText: "Reset Code",
                        prefixIcon: Icon(Iconsax.key),
                        counterText: "",
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Password input
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isVisible,
                      decoration: InputDecoration(
                        labelText: TTexts.password,
                        prefixIcon: const Icon(Iconsax.password_check),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _updatePassword,
                        child: _loading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Update Password"),
                      ),
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields * 1.8),

                    // Divider
                    const TFormDivider(dividerText1: TTexts.orGoBack),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
