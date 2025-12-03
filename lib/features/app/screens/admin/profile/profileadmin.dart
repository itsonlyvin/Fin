import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

// Ensure these imports match your project structure
import 'package:openarms/common/widgets/appbar/appbar.dart';
import 'package:openarms/features/app/screens/employee/profile/widgets/header.dart';
import 'package:openarms/features/app/screens/employee/profile/widgets/profile.dart';
import 'package:openarms/features/authentication/screens/onboarding/onboardging.dart';
import 'package:openarms/utils/appconfig.dart';
import 'package:openarms/utils/constants/sizes.dart';
import 'package:openarms/utils/employee_controller.dart';
import 'package:openarms/utils/navigation_menu.dart';
import 'package:openarms/utils/constants/colors.dart';
import 'package:openarms/utils/helpers/helper_functions.dart';

class ProfileScreenAdmin extends StatefulWidget {
  const ProfileScreenAdmin({super.key});

  @override
  State<ProfileScreenAdmin> createState() => _ProfileScreenAdminState();
}

class _ProfileScreenAdminState extends State<ProfileScreenAdmin> {
  // -- Controllers --
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _resetCodeController = TextEditingController();
  final TextEditingController _resetNewPassController = TextEditingController();
  final TextEditingController _emailVerifyCodeController =
      TextEditingController();

  // -- Keys --
  final _changePassFormKey = GlobalKey<FormState>();
  final _resetPassFormKey = GlobalKey<FormState>();

  // -- Visibility Toggles --
  bool _isOldVisible = false;
  bool _isNewVisible = false;
  bool _isResetPassVisible = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _resetCodeController.dispose();
    _resetNewPassController.dispose();
    _emailVerifyCodeController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // 🔹 API SERVICES
  // ===========================================================================

  Future<String> updateAdminPassword(
      {required String adminId,
      required String password,
      required String newPassword}) async {
    try {
      final response = await http.put(
        Uri.parse('${AppConfig.baseUrl}/admin/update-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'adminId': adminId,
          'password': password,
          'newPassword': newPassword
        }),
      );
      return response.statusCode == 200
          ? 'Password updated successfully'
          : response.body;
    } catch (e) {
      return 'Connection error: $e';
    }
  }

  Future<String> updateAdminName(String adminId, String newName) async {
    try {
      final response = await http.put(
          Uri.parse('${AppConfig.baseUrl}/admin/$adminId/update-name')
              .replace(queryParameters: {'name': newName}));
      return response.statusCode == 200 ? 'Success' : response.body;
    } catch (e) {
      return 'Connection error: $e';
    }
  }

  Future<String> updateAdminPhone(String adminId, String newPhone) async {
    try {
      final response = await http.put(
          Uri.parse('${AppConfig.baseUrl}/admin/$adminId/update-phone')
              .replace(queryParameters: {'phone': newPhone}));
      return response.statusCode == 200 ? 'Success' : response.body;
    } catch (e) {
      return 'Connection error: $e';
    }
  }

  Future<String> forgetPassword(String adminId) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/admin/forget-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'adminId': adminId}),
      );
      return response.statusCode == 200 ? 'Success' : response.body;
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> addNewPassword(String newPassword, String code) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/admin/add-new-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'newPassword': newPassword, 'code': code}),
      );
      return response.statusCode == 200 ? 'Success' : response.body;
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> verifyEmail(String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/admin/verify-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code}),
      );
      return response.statusCode == 200 ? 'Success' : response.body;
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> resendVerification(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/admin/resend-verification'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      return response.statusCode == 200 ? 'Success' : response.body;
    } catch (e) {
      return 'Error: $e';
    }
  }

  // ===========================================================================
  // 🔹 UI DIALOGS (FIXED: Using Get.dialog instead of showDialog)
  // ===========================================================================

  void _logout() {
    final storage = GetStorage();
    storage.erase();
    if (Get.isRegistered<EmployeeController>())
      Get.delete<EmployeeController>();
    if (Get.isRegistered<NavigationController>())
      Get.delete<NavigationController>();
    Get.offAll(() => const Onboardging());
  }

  /// 1. Generic Dialog to Update Name or Phone
  void _showEditDialog({
    required String title,
    required String currentValue,
    required Future<String> Function(String value) onSave,
    required VoidCallback onSuccess,
  }) {
    final controller = TextEditingController(text: currentValue);
    final formKey = GlobalKey<FormState>();
    bool isSaving = false;

    // FIX: Use Get.dialog instead of showDialog(context...)
    Get.dialog(
      StatefulBuilder(builder: (context, setDialogState) {
        return AlertDialog(
          title: Text('Update $title'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              validator: (v) =>
                  v == null || v.isEmpty ? 'Please enter a valid $title' : null,
              decoration: InputDecoration(labelText: 'New $title'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;
                      setDialogState(() => isSaving = true);

                      final result = await onSave(controller.text.trim());

                      // Check if dialog is still mounted logic is handled by Get.dialog implicitly if strictly following GetX,
                      // but setDialogState might throw if disposed.
                      // However, Get.dialog generally handles the context safely.
                      if (result == 'Success') {
                        Get.back(); // Close
                        onSuccess();
                        Get.snackbar('Success', '$title updated successfully',
                            backgroundColor: Colors.green.withOpacity(0.2));
                      } else {
                        setDialogState(() => isSaving = false);
                        Get.snackbar('Error', result,
                            backgroundColor: Colors.red.withOpacity(0.2));
                      }
                    },
              child: isSaving
                  ? const SizedBox(
                      width: 16, height: 16, child: CircularProgressIndicator())
                  : const Text('Save'),
            ),
          ],
        );
      }),
      barrierDismissible: false,
    );
  }

  /// 2. Email Verification Dialog
  void _showVerifyEmailDialog(String email) {
    _emailVerifyCodeController.clear();
    bool isProcessing = false;

    Get.dialog(
      StatefulBuilder(builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text('Verify Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('A code has been sent to:\n$email',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
              TextField(
                controller: _emailVerifyCodeController,
                decoration: const InputDecoration(
                    labelText: 'Verification Code',
                    prefixIcon: Icon(Iconsax.security_safe)),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: isProcessing
                      ? null
                      : () async {
                          setDialogState(() => isProcessing = true);
                          String res = await resendVerification(email);
                          setDialogState(() => isProcessing = false);
                          Get.snackbar(res == 'Success' ? 'Sent' : 'Error',
                              res == 'Success' ? 'Code resent' : res);
                        },
                  child: const Text('Resend Code'),
                ),
              )
            ],
          ),
          actions: [
            TextButton(
                onPressed: isProcessing ? null : () => Get.back(),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: isProcessing
                  ? null
                  : () async {
                      if (_emailVerifyCodeController.text.isEmpty) return;
                      setDialogState(() => isProcessing = true);
                      String res = await verifyEmail(
                          email, _emailVerifyCodeController.text.trim());

                      if (res == 'Success') {
                        Get.back();
                        final empController = Get.find<EmployeeController>();
                        empController.details['emailVerified'] = true;
                        empController.details.refresh();
                        Get.snackbar('Success', 'Verified successfully',
                            backgroundColor: Colors.green.withOpacity(0.2));
                      } else {
                        setDialogState(() => isProcessing = false);
                        Get.snackbar('Error', res,
                            backgroundColor: Colors.red.withOpacity(0.2));
                      }
                    },
              child: isProcessing
                  ? const SizedBox(
                      width: 16, height: 16, child: CircularProgressIndicator())
                  : const Text('Verify'),
            ),
          ],
        );
      }),
      barrierDismissible: false,
    );
  }

  /// 3. Reset Password Dialog
  void _showResetPasswordDialog() {
    _resetCodeController.clear();
    _resetNewPassController.clear();
    bool isProcessing = false;

    Get.dialog(
      StatefulBuilder(builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: Form(
            key: _resetPassFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Enter code sent to your email."),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _resetCodeController,
                  decoration: const InputDecoration(
                      labelText: 'Reset Code', prefixIcon: Icon(Iconsax.key)),
                  validator: (v) => v!.isEmpty ? 'Code required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _resetNewPassController,
                  obscureText: !_isResetPassVisible,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: const Icon(Iconsax.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_isResetPassVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => setDialogState(
                          () => _isResetPassVisible = !_isResetPassVisible),
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? 'Password required' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: isProcessing ? null : () => Get.back(),
                child: const Text("Cancel")),
            ElevatedButton(
              onPressed: isProcessing
                  ? null
                  : () async {
                      if (!_resetPassFormKey.currentState!.validate()) return;
                      setDialogState(() => isProcessing = true);
                      String res = await addNewPassword(
                          _resetNewPassController.text.trim(),
                          _resetCodeController.text.trim());

                      // We don't setDialogState to false here if successful because dialog closes immediately
                      if (res == 'Success') {
                        Get.back();
                        Get.snackbar('Success', 'Password reset successfully',
                            backgroundColor: Colors.green.withOpacity(0.2));
                      } else {
                        setDialogState(() => isProcessing = false);
                        Get.snackbar('Error', res,
                            backgroundColor: Colors.red.withOpacity(0.2));
                      }
                    },
              child: isProcessing
                  ? const SizedBox(
                      width: 16, height: 16, child: CircularProgressIndicator())
                  : const Text("Reset Password"),
            )
          ],
        );
      }),
      barrierDismissible: false,
    );
  }

  /// 4. Change Password Dialog
  void _showChangePasswordDialog() {
    _oldPasswordController.clear();
    _newPasswordController.clear();
    final empController = Get.find<EmployeeController>();
    bool isUpdating = false;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Change Password'),
            content: Form(
              key: _changePassFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _oldPasswordController,
                    obscureText: !_isOldVisible,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_isOldVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () => setStateDialog(
                            () => _isOldVisible = !_isOldVisible),
                      ),
                    ),
                  ),

                  // --- FORGOT PASSWORD ---
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        // 1. Close current dialog immediately
                        Get.back();

                        // 2. Show loading
                        Get.dialog(
                            const Center(child: CircularProgressIndicator()),
                            barrierDismissible: false);

                        // 3. API Call
                        String res =
                            await forgetPassword(empController.empId.value);

                        // 4. Close loading
                        Get.back();

                        if (res == 'Success') {
                          // 5. Open Reset Dialog (No 'context' needed!)
                          _showResetPasswordDialog();
                        } else {
                          Get.snackbar("Error", res,
                              backgroundColor: Colors.red.withOpacity(0.2));
                        }
                      },
                      child: const Text("Forgot Password?",
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),

                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: !_isNewVisible,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_isNewVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () => setStateDialog(
                            () => _isNewVisible = !_isNewVisible),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: isUpdating ? null : () => Get.back(),
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: isUpdating
                    ? null
                    : () async {
                        if (!(_changePassFormKey.currentState?.validate() ??
                            false)) return;
                        setStateDialog(() => isUpdating = true);

                        String response = await updateAdminPassword(
                          adminId: empController.empId.value,
                          password: _oldPasswordController.text.trim(),
                          newPassword: _newPasswordController.text.trim(),
                        );

                        if (response == 'Password updated successfully') {
                          Get.back();
                          Get.snackbar('Success', response,
                              backgroundColor: Colors.green.withOpacity(0.2));
                        } else {
                          setStateDialog(() => isUpdating = false);
                          Get.snackbar('Error', response,
                              backgroundColor: Colors.red.withOpacity(0.2));
                        }
                      },
                child: isUpdating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Update'),
              ),
            ],
          );
        },
      ),
      barrierDismissible: false,
    );
  }

  // ===========================================================================
  // 🔹 BUILD METHOD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final empController = Get.find<EmployeeController>();
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor:
          isDark ? const Color.fromARGB(255, 0, 0, 0) : TColors.white,
      appBar: const TAppBar(showBackArrow: false, title: Text('Profile Admin')),
      body: Obx(() {
        final details = empController.details;
        final bool isVerified = details['emailVerified'] == true;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                const Divider(),
                const TSectionHeading(
                    title: 'Personal Information', showActionButton: false),
                const SizedBox(height: TSizes.spaceBtwItems),

                // 1. UPDATE NAME
                TProfileMenu(
                  onPressed: () {
                    _showEditDialog(
                      title: 'Name',
                      currentValue: details['fullName'] ?? '',
                      onSave: (val) async {
                        String result = await updateAdminName(
                            empController.empId.value, val);
                        if (result == 'Success') {
                          empController.details['fullName'] = val;
                          empController.details.refresh();
                        }
                        return result;
                      },
                      onSuccess: () {},
                    );
                  },
                  title: 'Name',
                  value: details['fullName'] ?? 'N/A',
                ),

                // 2. READ ONLY ID
                TProfileMenu(
                    onPressed: () {},
                    title: 'User ID',
                    value: empController.empId.value,
                    icon: Iconsax.copy),

                // 3. EMAIL
                TProfileMenu(
                  onPressed: () {
                    if (!isVerified) {
                      _showVerifyEmailDialog(details['companyEmail'] ?? '');
                    } else {
                      Get.snackbar("Verified", "Your email is already verified",
                          backgroundColor: Colors.green.withOpacity(0.2));
                    }
                  },
                  title: 'E-mail',
                  value: details['companyEmail'] ?? 'N/A',
                  icon: isVerified ? Iconsax.verify5 : Iconsax.warning_2,
                ),

                if (!isVerified)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10, bottom: 10),
                      child: Text(
                        "Tap email to verify",
                        style: TextStyle(fontSize: 10, color: Colors.orange),
                      ),
                    ),
                  ),

                // 4. UPDATE PHONE
                TProfileMenu(
                  onPressed: () {
                    _showEditDialog(
                      title: 'Phone',
                      currentValue: details['phoneNumber'] ?? '',
                      onSave: (val) async {
                        String result = await updateAdminPhone(
                            empController.empId.value, val);
                        if (result == 'Success') {
                          empController.details['phoneNumber'] = val;
                          empController.details.refresh();
                        }
                        return result;
                      },
                      onSuccess: () {},
                    );
                  },
                  title: 'Phone',
                  value: details['phoneNumber'] ?? 'N/A',
                ),

                const Divider(),
                const SizedBox(height: TSizes.spaceBtwItems),

                // 5. CHANGE PASSWORD
                GestureDetector(
                  onTap: () => _showChangePasswordDialog(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: TSizes.spaceBtwItems / 1.5),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 7,
                            child: Text("Change Password",
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis)),
                        const Expanded(child: Icon(Iconsax.lock, size: 18))
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                const Divider(),

                Center(
                    child: TextButton(
                        onPressed: _logout,
                        child: const Text('Log Out',
                            style: TextStyle(color: TColors.absent)))),
              ],
            ),
          ),
        );
      }),
    );
  }
}
