import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:t_store/employee_controller.dart';
import 'package:t_store/features/app/screens/admin/home/backservice/AttendanceReport.dart';
import 'package:t_store/features/app/screens/admin/home/backservice/daily_attendance.dart';
import 'package:t_store/features/app/screens/admin/home/backservice/employee_model.dart';
import 'package:t_store/features/app/screens/admin/home/backservice/employeeservice.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/constants/sizes.dart';

class EmployeeInfo extends StatefulWidget {
  final String? employeeId;
  final String? employeeName;

  const EmployeeInfo({super.key, this.employeeId, this.employeeName});

  @override
  State<EmployeeInfo> createState() => _EmployeeInfoState();
}

class _EmployeeInfoState extends State<EmployeeInfo> {
  final EmployeeService employeeService = EmployeeService();
  late final String employeeId;
  late int selectedYear;
  late int selectedMonth;
  late Future<List<DailyAttendance>> attendanceFuture;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedYear = now.year;
    selectedMonth = now.month;

    // Use employeeId from widget or from controller
    final empController = Get.find<EmployeeController>();
    employeeId = widget.employeeId ?? empController.empId.value;

    fetchAttendance();
  }

  void fetchAttendance() {
    setState(() {
      attendanceFuture = employeeService.fetchMonthlyAttendance(
        employeeId,
        selectedYear,
        selectedMonth,
      );
    });
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "present":
        return TColors.present;
      case "absent":
        return TColors.absent;
      case "half-day":
        return TColors.halfDay;
      case "holiday":
        return TColors.holiday;
      default:
        return TColors.nodata;
    }
  }

  void fetchEmployeeAndShowDetails() async {
    try {
      final employee = await employeeService.fetchEmployeeById(employeeId);
      showEmployeeDetails(employee);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch employee details: $e")),
      );
    }
  }

  void fetchReportAndShow() async {
    try {
      final report = await employeeService.fetchMonthlyReport(
          employeeId, selectedYear, selectedMonth);
      showReportBottomSheet(report);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch report: $e")),
      );
    }
  }

  void showReportBottomSheet(AttendanceReport report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Monthly Report",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Text("Employee: ${report.employeeName}"),
                Text("Month: ${report.month}/${report.year}"),
                const SizedBox(height: 8),
                Text("Total Days: ${report.totalDays}"),
                Text("Days Left: ${report.daysLeft}"),
                Text("Present: ${report.presentDays}"),
                Text("Half Days: ${report.halfDays}"),
                Text("Absent: ${report.absentDays}"),
                Text("Paid Leave: ${report.paidLeave - report.holidayCount}"),
                Text("Holidays: ${report.holidayCount}"),
                const SizedBox(height: 8),
                Text(
                    "Total Hours: ${report.totalHoursWorked.toStringAsFixed(2)}"),
                Text(
                    "Overtime Hours: ${report.totalOvertimeHours.toStringAsFixed(2)}"),
                Text("Overtime Pay: ₹${report.overtimePay.toStringAsFixed(2)}"),
                Text(
                    "Salary Earned: ₹${report.salaryEarned.toStringAsFixed(2)}"),
                Text("Bonus: ₹${report.bonusEarned.toStringAsFixed(2)}"),
                Text(
                  "Total Salary: ₹${(report.bonusEarned + report.salaryEarned + report.overtimePay).toStringAsFixed(2)}",
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showEmployeeDetails(Employee employee) {
    final TextEditingController salaryController =
        TextEditingController(text: employee.salary.toString());
    final TextEditingController bonusController =
        TextEditingController(text: employee.bonus.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Employee Details",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Text("Name: ${employee.fullName}"),
                Text("ID: ${employee.employeeId}"),
                Text("Email: ${employee.companyEmail}"),
                Text("Phone: ${employee.phoneNumber}"),
                Text("Salary: ${employee.salary}"),
                Text("bonus: ${employee.bonus}"),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDayDetails(DailyAttendance day) {
    bool isPresent = day.status.toLowerCase() == "present";
    bool halfDay = day.status.toLowerCase() == "half-day";
    bool allowOvertime = day.overtimeEnabled ?? false;
    TextEditingController remarksController =
        TextEditingController(text: day.adminRemarks ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 16,
                left: 16,
                right: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                        const Icon(Icons.calendar_today,
                            color: TColors.primary),
                        const SizedBox(width: 8),
                        Text(DateFormat.yMMMMd().format(day.date),
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text("Current Status: ${day.status}"),
                    if (day.clockIn != null)
                      Text("Clock In: ${DateFormat.jm().format(day.clockIn!)}"),
                    if (day.clockOut != null)
                      Text(
                          "Clock Out: ${DateFormat.jm().format(day.clockOut!)}"),
                    if (day.totalHours != null)
                      Text("Total Hours: ${day.totalHours}"),
                    Text("Admin Remarks: ${day.adminRemarks}"),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Center(child: Text("Close")),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final years = List.generate(5, (i) => DateTime.now().year - i);
    final months = List.generate(12, (i) => i + 1);
    final empController = Get.find<EmployeeController>();

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
            InkWell(
              onTap: fetchEmployeeAndShowDetails,
              splashColor: TColors.primary.withOpacity(0.3),
              highlightColor: TColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: const ListTile(
                  title: Text("Details"),
                  leading: CircleAvatar(
                    backgroundColor: TColors.primary,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.defaultSpace),
            InkWell(
              splashColor: TColors.primary.withOpacity(0.3),
              highlightColor: TColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              onTap: fetchReportAndShow,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: TColors.primary,
                    child: Icon(Icons.assignment, color: Colors.white),
                  ),
                  title: Text("View Monthly Report"),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: TSizes.defaultSpace),
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
                          .map((y) =>
                              DropdownMenuItem(value: y, child: Text("$y")))
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

                    final Map<int, DailyAttendance> dayMap = {
                      for (var d in attendance) d.day: d
                    };
                    final List<Widget> dayWidgets = [];

                    const weekdays = [
                      "Mon",
                      "Tue",
                      "Wed",
                      "Thu",
                      "Fri",
                      "Sat",
                      "Sun"
                    ];
                    dayWidgets.addAll(weekdays.map((w) => Center(
                        child: Text(w,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)))));

                    for (int i = 1; i < firstDay; i++) {
                      dayWidgets.add(const SizedBox());
                    }

                    for (int day = 1; day <= daysInMonth; day++) {
                      final daily = dayMap[day];
                      final status = daily?.status ?? "No Data";
                      final color = getStatusColor(status);

                      dayWidgets.add(GestureDetector(
                        onTap:
                            daily != null ? () => showDayDetails(daily) : null,
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
                      ));
                    }

                    return GridView.count(
                        crossAxisCount: 7, children: dayWidgets);
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
