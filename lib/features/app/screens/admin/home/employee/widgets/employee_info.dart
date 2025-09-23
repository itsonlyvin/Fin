import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:t_store/features/app/screens/admin/home/backservice/DailyAttendance.dart';
import 'package:t_store/features/app/screens/admin/home/backservice/employeeservice%20.dart';
import 'package:t_store/utils/constants/sizes.dart';

class EmployeeInfo extends StatefulWidget {
  final String employeeId;
  final String employeeName;

  const EmployeeInfo({
    super.key,
    required this.employeeId,
    required this.employeeName,
  });

  @override
  State<EmployeeInfo> createState() => _EmployeeInfoState();
}

class _EmployeeInfoState extends State<EmployeeInfo> {
  final EmployeeService employeeService = EmployeeService();

  late int selectedYear;
  late int selectedMonth;

  late Future<List<DailyAttendance>> attendanceFuture;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedYear = now.year;
    selectedMonth = now.month;
    attendanceFuture = employeeService.fetchMonthlyAttendance(
      widget.employeeId,
      selectedYear,
      selectedMonth,
    );
  }

  void fetchAttendance() {
    setState(() {
      attendanceFuture = employeeService.fetchMonthlyAttendance(
        widget.employeeId,
        selectedYear,
        selectedMonth,
      );
    });
  }

  // Helper to get color by status
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "present":
        return Colors.green;
      case "absent":
        return Colors.red;
      case "half-day":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Show bottom sheet when a day is clicked
  void showDayDetails(int day, String status) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Attendance Details",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat.yMMMMd()
                        .format(DateTime(selectedYear, selectedMonth, day)),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    "Status: $status",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final years = List.generate(5, (i) => DateTime.now().year - i);
    final months = List.generate(12, (i) => i + 1);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: TSizes.appBarHeight,
          left: TSizes.defaultSpace,
          right: TSizes.defaultSpace,
          bottom: TSizes.defaultSpace,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Employee Header
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(widget.employeeName,
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text("ID: ${widget.employeeId}"),
              ),
            ),
            const SizedBox(height: TSizes.defaultSpace),

            // Month & Year selection
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: DropdownButtonFormField<int>(
                      value: selectedMonth,
                      decoration: const InputDecoration(
                        labelText: "Month",
                        border: OutlineInputBorder(),
                      ),
                      items: months
                          .map((m) => DropdownMenuItem(
                                value: m,
                                child: Text(DateFormat.MMMM()
                                    .format(DateTime(DateTime.now().year, m))),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          selectedMonth = val;
                          fetchAttendance();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: DropdownButtonFormField<int>(
                      value: selectedYear,
                      decoration: const InputDecoration(
                        labelText: "Year",
                        border: OutlineInputBorder(),
                      ),
                      items: years
                          .map((y) => DropdownMenuItem(
                                value: y,
                                child: Text(y.toString()),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          selectedYear = val;
                          fetchAttendance();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Calendar-like Attendance View
            Expanded(
              child: FutureBuilder<List<DailyAttendance>>(
                future: attendanceFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text("No attendance data found"));
                  } else {
                    final attendance = snapshot.data!;
                    final daysInMonth =
                        DateUtils.getDaysInMonth(selectedYear, selectedMonth);
                    final firstDay =
                        DateTime(selectedYear, selectedMonth, 1).weekday;

                    // Attendance map
                    final Map<int, String> statusByDay = {};
                    for (var day in attendance) {
                      statusByDay[day.day] = day.status;
                    }

                    // Build calendar cells
                    final List<Widget> dayWidgets = [];

                    // Weekday headers
                    const weekdays = [
                      "Mon",
                      "Tue",
                      "Wed",
                      "Thu",
                      "Fri",
                      "Sat",
                      "Sun"
                    ];
                    dayWidgets.addAll(
                      weekdays.map(
                        (w) => Center(
                          child: Text(
                            w,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );

                    // Empty slots before first day
                    for (int i = 1; i < firstDay; i++) {
                      dayWidgets.add(const SizedBox());
                    }

                    // Actual days
                    for (int day = 1; day <= daysInMonth; day++) {
                      final status = statusByDay[day] ?? "No Data";
                      final color = getStatusColor(status);

                      dayWidgets.add(
                        GestureDetector(
                          onTap: () => showDayDetails(day, status),
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: color, width: 1.5),
                            ),
                            child: Center(
                              child: Text(
                                day.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return GridView.count(
                      crossAxisCount: 7, // 7 days a week
                      children: dayWidgets,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
