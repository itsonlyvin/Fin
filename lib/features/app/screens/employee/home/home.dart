import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:t_store/utils/appconfig.dart';
import 'package:t_store/utils/employee_controller.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

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
  bool isLoading = false;

  // Counter
  String elapsedTime = "00:00:00";
  Timer? _counterTimer;
  Timer? _refreshTimer;
  DateTime? _clockInTime;

  @override
  void initState() {
    super.initState();
    _fetchDailyAttendance();
    // Auto-refresh every 10 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _fetchDailyAttendance();
    });
  }

  @override
  void dispose() {
    _counterTimer?.cancel();
    _refreshTimer?.cancel();
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
      setState(() => isLoading = true);

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final url = Uri.parse(
          "${AppConfig.baseUrl}/api/attendance/daily/${empController.empId.value}?date=$today");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

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
      } else {
        throw Exception("Failed to fetch daily attendance");
      }
    } catch (e) {
      // optionally ignore errors for auto-refresh
    } finally {
      setState(() => isLoading = false);
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

      setState(() {
        elapsedTime = "$hours:$minutes:$seconds";
      });
    });
  }

  /// Mark IN/OUT attendance
  Future<void> _markAttendance(bool isIn) async {
    try {
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isIn
                ? "✅ Clocked IN successfully"
                : "✅ Clocked OUT successfully"),
            backgroundColor: Colors.green,
          ),
        );
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
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final now = DateTime.now();
    final formattedTime = DateFormat('hh:mm a').format(now);
    final formattedDate = DateFormat('EEEE, MMM d').format(now);
    final circleSize = MediaQuery.of(context).size.width * 0.6;

    final List<Map<String, dynamic>> items = [
      {"icon": Iconsax.clock, "value": inTime, "label": "In"},
      {"icon": Iconsax.clock, "value": outTime, "label": "Out"},
      {
        "icon": Iconsax.tick_circle,
        "value": "${totalHours} hrs",
        "label": "Hrs"
      },
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
            top: TSizes.appBarHeight,
            bottom: TSizes.defaultSpace,
            left: TSizes.defaultSpace,
            right: TSizes.defaultSpace),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Welcome ${empController.empId.value}",
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

                  // Attendance Circle with counter
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
                                  Text("Elapsed Time",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.white)),
                                  const SizedBox(height: 8),
                                  Text(elapsedTime,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(color: Colors.white)),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // IN/OUT Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () => _markAttendance(true),
                    child: const Text("Mark IN"),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () => _markAttendance(false),
                    child: const Text("Mark OUT"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.defaultSpace),

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
    );
  }
}
