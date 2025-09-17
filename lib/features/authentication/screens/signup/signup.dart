import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:t_store/features/authentication/screens/onboarding/onboardging.dart';
import 'package:t_store/features/authentication/screens/signup/emailconformation.dart';
import 'package:t_store/features/authentication/screens/signup/service/employee_service.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/text_strings.dart';
import 'package:t_store/common/widgets/login_signup/login_signup_divider.dart';

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
  bool isVisible = false;
  bool _loading = false; // 🔹 loading state
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _employeeId = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final bool finOpenArms = true;

  /// 🔹 Register function
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final result = await EmployeeService.registerEmployee(
        employeeId: _employeeId.text.trim(),
        fullName: _name.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        password: _password.text.trim(),
        finOpenArms: finOpenArms,
      );

      if (result['success'] == true) {
        Get.snackbar("Success", result['message']);
        Get.to(() => EmialConformation(
              logo: widget.logo,
              color1: widget.color1,
              color2: widget.color2,
              email: _email.text.trim(),
              isfin: widget.isfin,
            ));
      } else {
        Get.snackbar("Error", result['message']);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// Header
          TPrimaryHeaderContainer(
            logo: widget.logo,
            color1: widget.color1,
            color2: widget.color2,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.spaceBtwSections,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Text(
                      TTexts.signupTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Employee/Admin ID
                    TextFormField(
                      controller: _employeeId,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Employee ID is required";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText:
                            widget.admin ? TTexts.adminId : TTexts.employeeId,
                        prefixIcon: const Icon(Iconsax.personalcard),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Name
                    TextFormField(
                      controller: _name,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: TTexts.name,
                        prefixIcon: Icon(Iconsax.user),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Email
                    TextFormField(
                      controller: _email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        if (!value.contains("@")) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: TTexts.email,
                        prefixIcon: Icon(Iconsax.direct_right),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Phone
                    TextFormField(
                      controller: _phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone number is required";
                        }
                        if (value.length < 8) {
                          return "Enter a valid phone number";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: TTexts.phoneNo,
                        prefixIcon: Icon(Iconsax.mobile),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    /// Password
                    TextFormField(
                      controller: _password,
                      obscureText: !isVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: TTexts.password,
                        prefixIcon: const Icon(Iconsax.password_check),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () =>
                              setState(() => isVisible = !isVisible),
                        ),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    ///  Account Button (with spinner)
                    SizedBox(
                      width: double.infinity,
                      //height: 60, // keep consistent height
                      child: ElevatedButton(
                        onPressed: _loading ? null : _register,
                        child: _loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(TTexts.createAccount),
                      ),
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields * 1.8),

                    /// Divider
                    const TFormDivider(
                      dividerText1: TTexts.orSignUpWith,
                      dividerText2: TTexts.orGoBack,
                      isSecond: true,
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields / 6),

                    /// Navigation Links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text(TTexts.signIn),
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
          ),
        ],
      ),
    );
  }
}
