import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/features/authentication/screens/signup/service/confirm_email_service.dart';
import 'package:t_store/features/authentication/screens/login/login.dart';
import 'package:t_store/features/authentication/screens/onboarding/onboardging.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:t_store/common/widgets/login_signup/login_signup_divider.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/text_strings.dart';

class EmailConfirmation extends StatefulWidget {
  const EmailConfirmation({
    super.key,
    required this.logo,
    required this.color1,
    required this.color2,
    required this.email,
    required this.isfin,
    this.admin = false,
  });

  final String logo;
  final Color color1;
  final Color color2;
  final String email;
  final bool isfin;
  final bool admin;

  @override
  State<EmailConfirmation> createState() => _EmailConfirmationState();
}

class _EmailConfirmationState extends State<EmailConfirmation> {
  final TextEditingController _pinController = TextEditingController();
  bool _loading = false;

  /// Verify Pin
  Future<void> _verifyPin() async {
    final pin = _pinController.text.trim();
    if (pin.length != 4) {
      Get.snackbar("Error", "Enter a valid 4-digit code");
      return;
    }

    setState(() => _loading = true);

    try {
      final response = widget.admin
          ? await ApiService.verifyAdminEmail(widget.email, pin)
          : await ApiService.verifyEmployeeEmail(widget.email, pin);

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Email Verified!");
        Get.offAll(() => LoginScreen(
              logo: widget.logo,
              color1: widget.color1,
              color2: widget.color2,
              isfin: widget.isfin,
            ));
      } else {
        Get.snackbar("Failed", response.body);
      }
    } catch (e) {
      Get.snackbar("Error", "Server not reachable");
    } finally {
      setState(() => _loading = false);
    }
  }

  /// Resend Code
  Future<void> _resendCode() async {
    setState(() => _loading = true);

    try {
      final response = widget.admin
          ? await ApiService.resendAdminVerification(widget.email)
          : await ApiService.resendEmployeeVerification(widget.email);

      if (response.statusCode == 200) {
        Get.snackbar("Resent", "New code sent to ${widget.email}");
      } else {
        Get.snackbar("Failed", response.body);
      }
    } catch (e) {
      Get.snackbar("Error", "Server not reachable");
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
              child: Column(
                children: [
                  Text(
                    TTexts.confirmEmail,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// PIN input
                  TextFormField(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: const InputDecoration(
                      labelText: TTexts.pin,
                      prefixIcon: Icon(Iconsax.password_check),
                      counterText: "",
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  /// Verify Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _verifyPin,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(TTexts.tContinue),
                    ),
                  ),

                  const SizedBox(height: TSizes.spaceBtwInputFields * 1.8),

                  const TFormDivider(
                    dividerText1: "Resend Email",
                    dividerText2: TTexts.orGoBack,
                    isSecond: true,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _loading ? null : _resendCode,
                        child: const Text("Resend Email"),
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
          ],
        ),
      ),
    );
  }
}
