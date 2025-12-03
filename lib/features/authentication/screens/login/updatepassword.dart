import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openarms/features/authentication/auth_template.dart';
import 'package:openarms/features/authentication/screens/login/login.dart';
import 'package:openarms/features/authentication/screens/onboarding/onboardging.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({
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
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  bool _isVisible = false;

  Future<void> _updatePassword() async {
    if (_codeController.text.isEmpty || _passwordController.text.isEmpty) {
      Get.snackbar("Error", "Code and Password are required");
      return;
    }

    setState(() => _loading = true);

    // Mock delay for demo
    await Future.delayed(const Duration(seconds: 1));
    Get.snackbar("Success", "Password updated!");

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

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      heroTag: "updateLogo",
      logo: widget.logo,
      color1: widget.color1,
      color2: widget.color2,
      title: widget.admin ? "Update Admin Password" : "Update Password",
      fields: [
        TextFormField(
          controller: _codeController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            labelText: "Reset Code",
            prefixIcon: Icon(Icons.key),
            counterText: "",
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isVisible,
          decoration: InputDecoration(
            labelText: "New Password",
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _isVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () => setState(() => _isVisible = !_isVisible),
            ),
          ),
        ),
      ],
      primaryButton: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: _loading ? null : _updatePassword,
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Update Password"),
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
