import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:openarms/common/widgets/login_signup/login_signup_divider.dart';
import 'package:openarms/features/authentication/auth_template.dart';
import 'package:openarms/features/authentication/screens/login/login.dart';
import 'package:openarms/features/authentication/screens/onboarding/onboardging.dart';
import 'package:openarms/features/authentication/screens/signup/service/employee_service.dart';
import 'package:openarms/utils/constants/sizes.dart';
import 'package:openarms/utils/constants/text_strings.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
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
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;
  bool isVisible = false;

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _idController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    Map<String, dynamic> response;

    // 1. Check if registering as Admin or Employee
    if (widget.admin) {
      response = await AuthService.registerAdmin(
        adminId: _idController.text.trim(),
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } else {
      response = await AuthService.registerEmployee(
        employeeId: _idController.text.trim(),
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
        finOpenArms: widget.isfin,
      );
    }

    setState(() => _loading = false);

    // 2. Handle Response
    if (response['success'] == true) {
      Get.snackbar(
        "Success",
        response['message'] ?? "Account created successfully!",
      );

      // Navigate to Login screen
      Get.offAll(
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
        "Registration Failed",
        response['message'] ?? "An unknown error occurred",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      heroTag: "signupLogo",
      logo: widget.logo,
      color1: widget.color1,
      color2: widget.color2,
      title: TTexts.signupTitle, // Using constant from TTexts
      formKey: _formKey,
      fields: [
        // ID Field
        TextFormField(
          controller: _idController,
          validator: (value) => value!.isEmpty
              ? "${widget.admin ? "Admin" : "Employee"} ID required"
              : null,
          decoration: InputDecoration(
            labelText: widget.admin ? TTexts.adminId : TTexts.employeeId,
            prefixIcon: const Icon(Iconsax.personalcard),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),

        // Name Field
        TextFormField(
          controller: _nameController,
          validator: (value) => value!.isEmpty ? "Name required" : null,
          decoration: const InputDecoration(
            labelText: "Full Name", // You can add TTexts.fullName if available
            prefixIcon: Icon(Iconsax.user),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),

        // Email Field
        TextFormField(
          controller: _emailController,
          validator: (value) {
            if (value == null || value.isEmpty) return "Email required";
            if (!GetUtils.isEmail(value)) return "Enter valid email";
            return null;
          },
          decoration: const InputDecoration(
            labelText: TTexts.email,
            prefixIcon: Icon(Iconsax.direct),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),

        // Phone Field
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) return "Phone required";
            if (value.length < 8) return "Enter valid phone number";
            return null;
          },
          decoration: const InputDecoration(
            labelText: TTexts.phoneNo,
            prefixIcon: Icon(Iconsax.call),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwInputFields),

        // Password Field
        TextFormField(
          controller: _passwordController,
          obscureText: !isVisible,
          validator: (value) {
            if (value == null || value.isEmpty) return "Password required";
            if (value.length < 6) return "Password must be 6+ chars";
            return null;
          },
          decoration: InputDecoration(
            labelText: TTexts.password,
            prefixIcon: const Icon(Iconsax.password_check),
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => isVisible = !isVisible),
            ),
          ),
        ),
      ],
      primaryButton: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: _loading ? null : _register,
          child: _loading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : const Text(TTexts.createAccount),
        ),
      ),
      divider: const TFormDivider(
        dividerText1: TTexts.orSignUpWith,
        dividerText2: TTexts.orGoBack,
        isSecond: true,
      ),
      secondaryActions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(TTexts.signIn),
        ),
        TextButton(
          onPressed: () => Get.to(() => const Onboardging(),
              transition: Transition.rightToLeft),
          child: const Text(TTexts.home),
        ),
      ],
    );
  }
}
