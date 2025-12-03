import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:openarms/features/app/screens/admin/home/backservice/employee_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:openarms/utils/appconfig.dart';
import 'package:openarms/utils/employee_controller.dart';
import 'package:openarms/utils/constants/sizes.dart';
import 'package:openarms/utils/helpers/helper_functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final empController = Get.find<EmployeeController>();

  String status = "--";
  String inTime = "--:--";
  String outTime = "--:--";
  String totalHours = "00:00";
  String adminRemarks = "";

  // CHANGE 1: Set this to true initially so the page starts in loading state
  bool isLoading = true;

  // Counter
  String elapsedTime = "00:00:00";
  Timer? _counterTimer;
  DateTime? _clockInTime;

  @override
  void initState() {
    super.initState();
    _fetchDailyAttendance();
  }

  @override
  void dispose() {
    _counterTimer?.cancel();
    super.dispose();
  }

  /// Ask for permissions
  Future<void> _requestPermissions() async {
    await [Permission.camera, Permission.location].request();
  }

  /// Get current location
  Future<Position> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception("Location services disabled");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permanently denied");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Scan QR code
  Future<String?> _scanQr() async {
    await _requestPermissions();
    String? scannedCode;

    await showDialog(
      context: context,
      builder: (context) {
        return Scaffold(
          body: Stack(
            children: [
              MobileScanner(
                onDetect: (barcodeCapture) {
                  final barcodes = barcodeCapture.barcodes;
                  if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                    scannedCode = barcodes.first.rawValue;
                    Navigator.pop(context);
                  }
                },
              ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Center(
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    return scannedCode;
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("❌ Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  /// Fetch daily attendance
  Future<void> _fetchDailyAttendance() async {
    try {
      if (!mounted) return;

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final url = Uri.parse(
          "${AppConfig.baseUrl}/api/attendance/daily/${empController.empId.value}?date=$today");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (mounted) {
          setState(() {
            status = data["status"] ?? "--";
            inTime = data["clockIn"] != null
                ? DateFormat('hh:mm a').format(DateTime.parse(data["clockIn"]))
                : "--:--";
            outTime = data["clockOut"] != null
                ? DateFormat('hh:mm a').format(DateTime.parse(data["clockOut"]))
                : "--:--";
            totalHours = data["totalHours"]?.toStringAsFixed(2) ?? "00:00";
            adminRemarks = data["adminRemarks"] ?? "";

            // Start or stop counter
            if (data["clockIn"] != null && data["clockOut"] == null) {
              _clockInTime = DateTime.parse(data["clockIn"]);
              _startCounter();
            } else {
              _counterTimer?.cancel();
              elapsedTime = "00:00:00";
            }
          });
        }
      } else {
        throw Exception("Failed to fetch daily attendance");
      }
    } catch (e) {
      // Handle error quietly or show toast
    } finally {
      // CHANGE 2: Turn off loading state here to reveal the UI
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// Start live counter
  void _startCounter() {
    _counterTimer?.cancel();
    if (_clockInTime == null) return;

    _counterTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final duration = now.difference(_clockInTime!);
      final hours = duration.inHours.toString().padLeft(2, '0');
      final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

      if (mounted) {
        setState(() {
          elapsedTime = "$hours:$minutes:$seconds";
        });
      }
    });
  }

  /// Mark IN/OUT attendance
  Future<void> _markAttendance(bool isIn) async {
    try {
      // For marking attendance, we might want to show a different loader
      // or keep the existing one. For now, we use the same flag.
      setState(() => isLoading = true);

      String? qrCode = await _scanQr();
      if (qrCode == null) throw Exception("No QR code scanned");

      Position position = await _getLocation();

      String url = isIn
          ? "${AppConfig.baseUrl}/api/attendance/in/${empController.empId.value}"
          : "${AppConfig.baseUrl}/api/attendance/out/${empController.empId.value}";

      final response = await http.post(Uri.parse(url), body: {
        "latitude": position.latitude.toString(),
        "longitude": position.longitude.toString(),
        "qrCode": qrCode,
      });

      if (response.statusCode == 200) {
        await _fetchDailyAttendance();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isIn
                  ? "✅ Clocked IN successfully"
                  : "✅ Clocked OUT successfully"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        String errorMessage = "Something went wrong!";
        try {
          final errorData = json.decode(response.body);
          errorMessage = errorData["message"] ??
              errorData["error"] ??
              "Server error (${response.statusCode})";
        } catch (_) {}
        _showErrorDialog(errorMessage);
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final now = DateTime.now();
    final formattedTime = DateFormat('hh:mm a').format(now);
    final formattedDate = DateFormat('EEEE, d MMMM y').format(now);
    final empController = Get.find<EmployeeController>();

    final bgColor =
        dark ? const Color.fromARGB(255, 0, 0, 0) : const Color(0xFFF5F5F5);
    final cardColor = dark ? const Color(0xFF2C2C2C) : Colors.white;
    final screenHeight = MediaQuery.of(context).size.height;
    final details = empController.details;
    final empId = empController.empId.value;

    final employee = Employee.fromJson({...details, "employeeId": empId});

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, ${employee.fullName}",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "Let's get to work!",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      // CHANGE 3: Logic to switch between Loader and Content
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Full screen loader
          : RefreshIndicator(
              onRefresh: _fetchDailyAttendance,
              color: Colors.white,
              backgroundColor: const Color.fromARGB(255, 29, 80, 129),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.defaultSpace),
                  child: Column(
                    children: [
                      const SizedBox(height: TSizes.spaceBtwSections),

                      SizedBox(
                        height: screenHeight * 0.30,
                        width: double.infinity,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 29, 80, 129),
                                Color.fromARGB(255, 206, 130, 220)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: dark ? Colors.black : Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Current Shift",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: Colors.grey,
                                        ),
                                  ),
                                  const SizedBox(height: TSizes.sm),
                                  Text(
                                    elapsedTime,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Monospace',
                                          color: dark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                  ),
                                  const SizedBox(height: TSizes.xs),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _clockInTime != null
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _clockInTime != null
                                          ? "ACTIVE"
                                          : "INACTIVE",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: _clockInTime != null
                                                ? Colors.green
                                                : Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: TSizes.spaceBtwSections),

                      // --- 2. DATE DISPLAY ---
                      Text(
                        formattedDate.toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              letterSpacing: 1.2,
                              color: Colors.grey,
                            ),
                      ),
                      Text(
                        formattedTime,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),

                      const SizedBox(height: TSizes.spaceBtwSections),

                      // --- 3. STATS GRID ---
                      Container(
                        padding: const EdgeInsets.all(TSizes.md),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius:
                              BorderRadius.circular(TSizes.cardRadiusLg),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(context, "Clock In", inTime,
                                Iconsax.login, Colors.green),
                            Container(
                                width: 1,
                                height: 40,
                                color: Colors.grey.withOpacity(0.3)),
                            _buildStatItem(context, "Clock Out", outTime,
                                Iconsax.logout, Colors.orange),
                            Container(
                                width: 1,
                                height: 40,
                                color: Colors.grey.withOpacity(0.3)),
                            _buildStatItem(context, "Total Hrs", totalHours,
                                Iconsax.timer_1, Colors.blue),
                          ],
                        ),
                      ),

                      const SizedBox(height: TSizes.spaceBtwSections),

                      // --- 4. ACTION SLIDE/BUTTONS ---
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _markAttendance(true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 29, 80, 129),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 5,
                              ),
                              icon: const Icon(Iconsax.scan_barcode),
                              label: const Text("CLOCK IN"),
                            ),
                          ),
                          const SizedBox(width: TSizes.md),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _markAttendance(false),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 206, 130, 220),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 5,
                              ),
                              icon: const Icon(Iconsax.logout_1),
                              label: const Text("CLOCK OUT"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.defaultSpace),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // Helper widget for the Stats Grid
  Widget _buildStatItem(BuildContext context, String label, String value,
      IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
