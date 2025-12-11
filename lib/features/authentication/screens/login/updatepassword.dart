import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:openarms/features/authentication/auth_template.dart';
import 'package:openarms/features/authentication/screens/login/forgetpassword.dart';
import 'package:openarms/features/authentication/screens/login/login.dart';
import 'package:openarms/features/authentication/screens/login/services/update_password_service.dart';
import 'package:openarms/features/authentication/screens/onboarding/onboardging.dart';
import 'package:openarms/utils/constants/text_strings.dart';
import 'package:openarms/common/widgets/login_signup/login_signup_divider.dart';

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
    final code = _codeController.text.trim();
    final password = _passwordController.text.trim();

    if (code.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Code and Password are required",
      );
      return;
    }

    setState(() => _loading = true);

    try {
      http.Response response;

      // Call the appropriate service based on role
      if (widget.admin) {
        response =
            await UpdatePasswordService.addAdminNewPassword(code, password);
      } else {
        response =
            await UpdatePasswordService.addEmployeeNewPassword(code, password);
      }

      setState(() => _loading = false);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          response.body, // "Password updated successfully"
        );

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
      } else {
        Get.snackbar(
          "Error",
          response.body, // Display backend error message
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      Get.snackbar(
        "Connection Error",
        "Failed to connect to server: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
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
      divider: const TFormDivider(
        dividerText1: TTexts.orGoBack,
        isSecond: true,
        dividerText2: TTexts.home,
      ),
      secondaryActions: [
        TextButton(
          onPressed: () => Get.to(
              () => ForgetPasswordScreen(
                    logo: widget.logo,
                    color1: widget.color1,
                    color2: widget.color2,
                    isfin: widget.isfin,
                    admin: widget.admin,
                  ),
              transition: Transition.leftToRight),
          child: const Text("Resend code"),
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
