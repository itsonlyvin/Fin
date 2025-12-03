import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:openarms/utils/appconfig.dart';

class ActiveQrCodePage extends StatefulWidget {
  const ActiveQrCodePage({super.key});

  @override
  State<ActiveQrCodePage> createState() => _ActiveQrCodePageState();
}

class _ActiveQrCodePageState extends State<ActiveQrCodePage> {
  late Future<QrCodeData> qrCodeFuture;

  @override
  void initState() {
    super.initState();
    qrCodeFuture = fetchActiveQr();
  }

  Future<QrCodeData> fetchActiveQr() async {
    // Replace with your Spring Boot backend URL
    final url = Uri.parse('${AppConfig.baseUrl}/active-qr');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return QrCodeData.fromJson(data);
    } else {
      throw Exception('Failed to fetch QR code');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Active QR Code"),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<QrCodeData>(
          future: qrCodeFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.red),
              );
            } else if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Scan this QR Code:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  QrImageView(
                    data: snapshot.data!.code, // QR code from backend
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                  const SizedBox(height: 16),
                  Text("Active from: ${snapshot.data!.startTime}"),
                  Text("Expires at: ${snapshot.data!.endTime}"),
                ],
              );
            } else {
              return const Text("No QR code found");
            }
          },
        ),
      ),
    );
  }
}

class QrCodeData {
  final String code;
  final String startTime;
  final String endTime;

  QrCodeData({
    required this.code,
    required this.startTime,
    required this.endTime,
  });

  factory QrCodeData.fromJson(Map<String, dynamic> json) {
    return QrCodeData(
      code: json['code'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}
