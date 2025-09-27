import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:t_store/appconfig.dart';
import 'package:t_store/employee_controller.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final empController = Get.find<EmployeeController>();

  String inTime = "--:--";
  String outTime = "--:--";
  String workedHours = "00:00";
  bool isLoading = false;

  /// ✅ Ask for permissions
  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.location,
    ].request();
  }

  /// ✅ Get location
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

  /// ✅ Scan QR code
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

  /// ✅ Error dialog
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

  /// ✅ Mark IN/OUT
  Future<void> _markAttendance(bool isIn) async {
    try {
      setState(() => isLoading = true);

      // 1. Scan QR
      String? qrCode = await _scanQr();
      if (qrCode == null) throw Exception("No QR code scanned");

      // 2. Location
      Position position = await _getLocation();

      // 3. API
      String url = isIn
          ? "${AppConfig.baseUrl}/api/attendance/in/${empController.empId.value}"
          : "${AppConfig.baseUrl}/api/attendance/out/${empController.empId.value}";

      final response = await http.post(
        Uri.parse(url),
        body: {
          "latitude": position.latitude.toString(),
          "longitude": position.longitude.toString(),
          "qrCode": qrCode,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          inTime = data["clockIn"] ?? inTime;
          outTime = data["clockOut"] ?? outTime;
          workedHours = data["totalHours"]?.toString() ?? workedHours;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isIn
                ? "✅ Clocked IN successfully"
                : "✅ Clocked OUT successfully"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // 🔥 Extract backend error
        String errorMessage = "Something went wrong!";
        try {
          final errorData = json.decode(response.body);
          if (errorData["message"] != null) {
            errorMessage = errorData["message"];
          } else if (errorData["error"] != null) {
            errorMessage = errorData["error"];
          } else {
            errorMessage = "Server error (${response.statusCode})";
          }
        } catch (_) {
          errorMessage = "Server error (${response.statusCode})";
        }

        _showErrorDialog(errorMessage);
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final now = DateTime.now();
    final formattedTime = DateFormat('hh:mm a').format(now);
    final formattedDate = DateFormat('EEEE, MMM d').format(now);
    final circleSize = MediaQuery.of(context).size.width * 0.5;

    final List<Map<String, dynamic>> items = [
      {"icon": Iconsax.clock, "value": inTime, "label": "In"},
      {"icon": Iconsax.clock, "value": outTime, "label": "Out"},
      {"icon": Iconsax.tick_circle, "value": workedHours, "label": "Hrs"},
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: TSizes.appBarHeight,
          bottom: TSizes.sm,
          left: TSizes.defaultSpace,
          right: TSizes.defaultSpace,
        ),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Welcome 👋 ${empController.empId.value}",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date & Time
                  Padding(
                    padding: const EdgeInsets.only(top: TSizes.appBarHeight),
                    child: Column(
                      children: [
                        Text(formattedTime,
                            style: Theme.of(context).textTheme.displayMedium),
                        const SizedBox(height: TSizes.sm),
                        Text(formattedDate,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),

                  // Attendance Circle
                  Padding(
                    padding: const EdgeInsets.only(bottom: TSizes.appBarHeight),
                    child: Container(
                      width: circleSize,
                      height: circleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 29, 80, 129),
                            Color.fromARGB(255, 206, 130, 220)
                          ],
                          stops: [0.1, 0.8],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: dark
                                ? Colors.black.withOpacity(0.6)
                                : Colors.grey.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Shift Time",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.white)),
                                  const SizedBox(height: TSizes.sm),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => _markAttendance(true),
                                        child: const Text("Mark IN"),
                                      ),
                                      const SizedBox(width: 20),
                                      ElevatedButton(
                                        onPressed: () => _markAttendance(false),
                                        child: const Text("Mark OUT"),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),

                  // IN/OUT/Hours
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: items.map((item) {
                      return Column(
                        children: [
                          Icon(item["icon"] as IconData, size: 28),
                          const SizedBox(height: TSizes.sm),
                          Text(item["value"] as String,
                              style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: TSizes.dividerHeight),
                          Text(item["label"] as String,
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      );
                    }).toList(),
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
