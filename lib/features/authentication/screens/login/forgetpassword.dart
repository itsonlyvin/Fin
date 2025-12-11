import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:openarms/features/authentication/auth_template.dart';
import 'package:openarms/features/authentication/screens/login/services/forget_password_service.dart';
import 'package:openarms/features/authentication/screens/login/updatepassword.dart';
import 'package:openarms/features/authentication/screens/onboarding/onboardging.dart';
import 'package:openarms/utils/constants/text_strings.dart';
import 'package:openarms/common/widgets/login_signup/login_signup_divider.dart';

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
    final id = _idController.text.trim();

    if (id.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter ${widget.admin ? "Admin ID" : "Employee ID"}",
      );
      return;
    }

    setState(() => _loading = true);

    try {
      http.Response response;

      // Call the appropriate service based on role
      if (widget.admin) {
        response = await ForgetPasswordService.sendAdminResetCode(id);
      } else {
        response = await ForgetPasswordService.sendEmployeeResetCode(id);
      }

      setState(() => _loading = false);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          response.body, // "Password reset code sent to your email."
        );

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
        isSecond: false,
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
