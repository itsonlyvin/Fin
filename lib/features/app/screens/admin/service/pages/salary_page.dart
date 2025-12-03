import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openarms/utils/appconfig.dart';
import 'package:openarms/utils/constants/colors.dart';
import 'package:openarms/utils/helpers/helper_functions.dart';

class SalaryPage extends StatefulWidget {
  const SalaryPage({super.key});

  @override
  State<SalaryPage> createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> {
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  List<dynamic> salaryData = [];
  bool isLoading = false;

  Future<void> fetchSalary() async {
    setState(() => isLoading = true);
    try {
      final url = Uri.parse(
          "${AppConfig.baseUrl}/api/salary/monthly/$selectedYear/$selectedMonth");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          salaryData = jsonDecode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSalary();
  }

  String formatCurrency(dynamic value) {
    if (value == null) return "0.00"; // handles null safely
    try {
      return (double.tryParse(value.toString()) ?? 0.0).toStringAsFixed(2);
    } catch (_) {
      return "0.00";
    }
  }

  @override
  Widget build(BuildContext context) {
    final years = List.generate(5, (i) => DateTime.now().year - i);
    final months = List.generate(12, (i) => i + 1);
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor:
          isDark ? const Color.fromARGB(255, 0, 0, 0) : TColors.white,
      appBar: AppBar(title: const Text('Monthly Salary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: selectedMonth,
                    decoration: const InputDecoration(
                      labelText: "Month",
                      border: OutlineInputBorder(),
                    ),
                    items: months
                        .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text("${DateTime(0, m).month}-$m")))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => selectedMonth = val);
                        fetchSalary();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: selectedYear,
                    decoration: const InputDecoration(
                      labelText: "Year",
                      border: OutlineInputBorder(),
                    ),
                    items: years
                        .map((y) =>
                            DropdownMenuItem(value: y, child: Text("$y")))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => selectedYear = val);
                        fetchSalary();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: salaryData.length,
                      itemBuilder: (context, index) {
                        final item = salaryData[index];
                        return Card(
                          child: ListTile(
                            title: Text(item['employeeName'] ?? ''),
                            subtitle: Text(
                              "Salary: ₹${formatCurrency(item['salary'])}, "
                              "Bonus: ₹${formatCurrency(item['bonus'])}",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
