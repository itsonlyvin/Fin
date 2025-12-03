import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openarms/features/authentication/auth_template.dart';
import 'package:openarms/features/authentication/screens/login/login.dart';
import 'package:openarms/features/authentication/screens/onboarding/onboardging.dart';

class EmailConfirmationScreen extends StatefulWidget {
  const EmailConfirmationScreen({
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
  State<EmailConfirmationScreen> createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _loading = false;

  Future<void> _verifyPin() async {
    if (_pinController.text.trim().length != 4) {
      Get.snackbar("Error", "Enter 4-digit code");
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));

    Get.snackbar("Success", "Email Verified!");

    setState(() => _loading = false);

    // Navigate to Login
    Get.off(
      () => LoginScreen(
        logo: widget.logo,
        color1: widget.color1,
        color2: widget.color2,
        admin: widget.admin,
        isfin: widget.isfin,
      ),
      transition: Transition.rightToLeft,
    );
  }

  Future<void> _resendCode() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    Get.snackbar("Sent", "New code sent to ${widget.email}");
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      heroTag: "emailLogo",
      logo: widget.logo,
      color1: widget.color1,
      color2: widget.color2,
      title: "Email Confirmation",
      fields: [
        TextFormField(
          controller: _pinController,
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: const InputDecoration(
            labelText: "4-digit code",
            prefixIcon: Icon(Icons.lock),
            counterText: "",
          ),
        ),
      ],
      primaryButton: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: _loading ? null : _verifyPin,
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Verify Email"),
        ),
      ),
      secondaryActions: [
        TextButton(
          onPressed: _loading ? null : _resendCode,
          child: const Text("Resend Email"),
        ),
        TextButton(
          onPressed: () => Get.to(() => const Onboardging(),
              transition: Transition.rightToLeft),
          child: const Text("Home"),
        ),
      ],
    );
  }
}
