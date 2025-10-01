import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:t_store/utils/appconfig.dart';

class EmpIdPage extends StatefulWidget {
  const EmpIdPage({super.key});

  @override
  State<EmpIdPage> createState() => _EmpIdPageState();
}

class _EmpIdPageState extends State<EmpIdPage> {
  List<Map<String, dynamic>> employees = [];
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchAllEmployees();
  }

  // Fetch all employee IDs
  Future<void> fetchAllEmployees() async {
    setState(() => loading = true);
    final url = Uri.parse("${AppConfig.baseUrl}/employee-ids/all_employees");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          employees = data
              .map((e) => {
                    "employeeId": e['employeeId'],
                    "registered": e['registered'] ?? false,
                  })
              .toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to fetch employees")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => loading = false);
    }
  }

  // Create Employee ID (not registered automatically)
  Future<void> createEmployeeId(String empId) async {
    final url = Uri.parse("${AppConfig.baseUrl}/employee-ids");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"employeeId": empId, "registered": false}),
      );
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Employee ID created")));
        employeeIdController.clear();
        fetchAllEmployees();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.body)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // Update registered status
  Future<void> updateRegisteredStatus(String empId, bool status) async {
    final url = Uri.parse(
        "${AppConfig.baseUrl}/employee-ids/$empId/update-registered?status=$status");
    try {
      final response = await http.put(url);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registered status updated")));
        fetchAllEmployees();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.body)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // Delete employee ID
  Future<void> deleteEmployeeId(String empId) async {
    final url = Uri.parse("${AppConfig.baseUrl}/employee-ids/$empId");
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        setState(() {
          employees.removeWhere((e) => e['employeeId'] == empId);
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Employee ID deleted")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.body)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // Confirm before deleting
  Future<void> confirmAndDeleteEmployeeId(String empId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete Employee ID: $empId?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      deleteEmployeeId(empId);
    }
  }

  // Get full Employee details (only Employee ID, Name, Phone, Email)
  Future<void> getEmployeeDetailsByMainService(String emp) async {
    final url = Uri.parse("${AppConfig.baseUrl}/employee/$emp");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Employee Details"),
            content: Text(
              "Employee ID: ${data['employeeId']}\n"
              "Name: ${data['fullName']}\n"
              "Phone: ${data['phoneNumber']}\n"
              "Email: ${data['companyEmail']}",
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"))
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.body)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error fetching details: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee IDs"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Create new Employee ID
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: employeeIdController,
                    decoration:
                        const InputDecoration(labelText: "Enter Employee ID"),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    final id = employeeIdController.text.trim();
                    if (id.isNotEmpty) createEmployeeId(id);
                  },
                  child: const Text("Create"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Search field
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Search Employee ID",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            // Employee list
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final emp = employees[index];
                        if (!emp['employeeId']
                            .toString()
                            .contains(searchController.text.trim())) {
                          return const SizedBox();
                        }
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(emp['employeeId']),
                            subtitle: Text(
                              emp['registered']
                                  ? "Registered"
                                  : "Not Registered",
                              style: TextStyle(
                                  color: emp['registered']
                                      ? Colors.green
                                      : Colors.red),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Toggle switch for registered
                                Switch(
                                  value: emp['registered'],
                                  onChanged: (val) => updateRegisteredStatus(
                                      emp['employeeId'], val),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Color.fromARGB(255, 209, 56, 46)),
                                  onPressed: () => confirmAndDeleteEmployeeId(
                                      emp['employeeId']),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.person),
                                  tooltip: "Get full Employee details",
                                  onPressed: () =>
                                      getEmployeeDetailsByMainService(
                                          emp['employeeId']),
                                ),
                              ],
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
