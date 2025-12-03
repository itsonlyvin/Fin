import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openarms/features/authentication/auth_template.dart';
import 'package:openarms/features/authentication/screens/login/updatepassword.dart';
import 'package:openarms/features/authentication/screens/onboarding/onboardging.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({
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
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _idController = TextEditingController();
  bool _loading = false;

  Future<void> _sendResetCode() async {
    if (_idController.text.trim().isEmpty) {
      Get.snackbar(
          "Error", "Please enter ${widget.admin ? "Admin ID" : "Employee ID"}");
      return;
    }

    setState(() => _loading = true);

    // Mock delay for demo
    await Future.delayed(const Duration(seconds: 1));
    Get.snackbar("Success", "Reset code sent!");

    setState(() => _loading = false);

    // Navigate to Update Password
    Get.to(
      () => UpdatePasswordScreen(
        logo: widget.logo,
        color1: widget.color1,
        color2: widget.color2,
        admin: widget.admin,
        isfin: widget.isfin,
      ),
      transition: Transition.rightToLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      heroTag: "forgetLogo",
      logo: widget.logo,
      color1: widget.color1,
      color2: widget.color2,
      title: widget.admin ? "Admin Password Reset" : "Forget Password",
      fields: [
        TextFormField(
          controller: _idController,
          decoration: InputDecoration(
            labelText: widget.admin ? "Admin ID" : "Employee ID",
            prefixIcon: const Icon(Icons.person),
          ),
        ),
      ],
      primaryButton: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: _loading ? null : _sendResetCode,
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Send Reset Code"),
        ),
      ),
      secondaryActions: [
        TextButton(
          onPressed: () => Get.to(() => const Onboardging(),
              transition: Transition.rightToLeft),
          child: const Text("Home"),
        ),
      ],
    );
  }
}
