import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:t_store/common/widgets/login_signup/login_signup_divider.dart';
import 'package:t_store/features/authentication/screens/login/services/forget_password_service.dart';
import 'package:t_store/features/authentication/screens/login/updatepassword.dart';
import 'package:t_store/features/authentication/screens/onboarding/onboardging.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/text_strings.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({
    super.key,
    required this.logo,
    required this.color1,
    required this.color2,
    required this.admin,
    required this.isfin,
  });

  final String logo;
  final Color color1;
  final Color color2;
  final bool admin;
  final bool isfin;

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  final TextEditingController _idController = TextEditingController();
  bool _loading = false;

  Future<void> _sendResetCode() async {
    if (_idController.text.trim().isEmpty) {
      Get.snackbar(
          "Error", "Please enter ${widget.admin ? "Admin ID" : "Employee ID"}");
      return;
    }

    setState(() => _loading = true);

    try {
      final response = widget.admin
          ? await ForgetPasswordService.sendAdminResetCode(
              _idController.text.trim())
          : await ForgetPasswordService.sendEmployeeResetCode(
              _idController.text.trim());

      if (response.statusCode == 200) {
        Get.snackbar("Success", response.body);

        // Navigate to Update Password screen
        Get.to(() => Updatepassword(
              logo: widget.logo,
              color1: widget.color1,
              color2: widget.color2,
              admin: widget.admin,
              isfin: widget.isfin,
            ));
      } else {
        Get.snackbar("Failed", response.body);
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
                      widget.admin
                          ? "Admin Password Reset"
                          : TTexts.forgetPassword,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: _idController,
                      decoration: InputDecoration(
                        labelText:
                            widget.admin ? TTexts.adminId : TTexts.employeeId,
                        prefixIcon: const Icon(Iconsax.personalcard),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _sendResetCode,
                        child: _loading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(TTexts.sendEmail),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields * 1.8),
                    const TFormDivider(dividerText1: TTexts.orGoBack),
                    const SizedBox(height: TSizes.spaceBtwInputFields / 6),
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
