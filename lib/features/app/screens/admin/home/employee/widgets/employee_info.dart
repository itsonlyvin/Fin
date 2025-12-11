import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:openarms/features/app/screens/employee/profile/widgets/profile.dart';
import 'package:openarms/utils/constants/sizes.dart';
import 'package:openarms/utils/employee_controller.dart';
import 'package:openarms/features/app/screens/admin/home/backservice/attendance_report.dart';
import 'package:openarms/features/app/screens/admin/home/backservice/daily_attendance.dart';
import 'package:openarms/features/app/screens/admin/home/backservice/employee_model.dart';
import 'package:openarms/features/app/screens/admin/home/backservice/employeeservice.dart';
import 'package:openarms/utils/constants/colors.dart';
import 'package:openarms/utils/helpers/helper_functions.dart';
import 'package:table_calendar/table_calendar.dart';

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

  // Calendar State
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Data State
  List<DailyAttendance> _attendanceList = [];
  bool _isLoading = false;

  // Report Loading State
  bool _isReportLoading = false;

  @override
  void initState() {
    super.initState();

    // Use employeeId from widget or from controller
    final empController = Get.find<EmployeeController>();
    employeeId = widget.employeeId ?? empController.empId.value;

    _fetchAttendanceForMonth(_focusedDay);
  }

  /// Helper for time validation
  int _timeToMinutes(String time) {
    try {
      final parts = time.split(':');
      if (parts.length < 2) return 0;
      final h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      return h * 60 + m;
    } catch (_) {
      return 0;
    }
  }

  /// Fetch data. If [isRefresh] is true, we don't show the full-screen loader.
  Future<void> _fetchAttendanceForMonth(DateTime date,
      {bool isRefresh = false}) async {
    if (!isRefresh) {
      setState(() => _isLoading = true);
    }

    try {
      final data = await employeeService.fetchMonthlyAttendance(
        employeeId,
        date.year,
        date.month,
      );
      setState(() {
        _attendanceList = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching data: $e")),
        );
      }
    }
  }

  /// Helper to find attendance data for a specific day
  DailyAttendance? _getAttendanceForDay(DateTime day) {
    try {
      return _attendanceList.firstWhere(
        (att) => isSameDay(att.date, day),
      );
    } catch (_) {
      return null;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "present":
        return TColors.success; // Green
      case "absent":
        return TColors.error; // Red
      case "half-day":
        return TColors.warning; // Orange
      case "holiday":
        return TColors.primary; // Brand color
      default:
        return Colors.grey;
    }
  }

  // ------------------- UI BUILDERS -------------------

  Widget _buildEmployeeHeaderCard(bool isDark) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      color: isDark ? const Color.fromARGB(255, 0, 0, 0) : TColors.light,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: TColors.primary.withOpacity(0.1),
              child: const Icon(Icons.person, color: TColors.primary, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.employeeName ?? "Employee",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "ID: $employeeId",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_note, color: TColors.primary),
              onPressed: fetchEmployeeAndShowDetails,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDayDetail(bool isDark) {
    final DailyAttendance? data = _getAttendanceForDay(_selectedDay);

    if (data == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const Icon(Icons.info_outline, color: Colors.grey, size: 40),
              const SizedBox(height: 10),
              Text(
                "No data for ${DateFormat.yMMMMd().format(_selectedDay)}",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    final color = getStatusColor(data.status);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: () => showDayDetails(data),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat.yMMMMd().format(data.date),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                data.status.toUpperCase(),
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            )
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.login, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    data.clockIn != null
                        ? DateFormat('hh:mm a').format(data.clockIn!)
                        : "--:--",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.logout, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    data.clockOut != null
                        ? DateFormat('hh:mm a').format(data.clockOut!)
                        : "--:--",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (data.totalHours != null)
                Text(
                    "Total: ${data.totalHours!.floor()}h ${((data.totalHours! - data.totalHours!.floor()) * 60).round()}m",
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              if (data.adminRemarks != null && data.adminRemarks!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "Note: ${data.adminRemarks}",
                    style: const TextStyle(
                        color: TColors.primary,
                        fontStyle: FontStyle.italic,
                        fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDark
          ? const Color.fromARGB(255, 0, 0, 0)
          : const Color.fromARGB(255, 255, 255, 255)
              .withAlpha((255 * 0.1).toInt()),
      appBar: AppBar(
        title: const Text("Attendance Record"),
        centerTitle: true,
        actions: [
          // Show loader if fetching report
          if (_isReportLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.summarize_outlined),
              tooltip: "Monthly Report",
              onPressed: fetchReportAndShow,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchAttendanceForMonth(_focusedDay, isRefresh: true);
        },
        color: TColors.white,
        backgroundColor: TColors.primary,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Calendar Card
                    Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      color: isDark ? TColors.dark : TColors.light,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TableCalendar(
                          focusedDay: _focusedDay,
                          firstDay: DateTime(2020),
                          lastDay: DateTime(2030),
                          calendarFormat: CalendarFormat.month,
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          selectedDayPredicate: (day) =>
                              isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          onPageChanged: (focusedDay) {
                            setState(() => _focusedDay = focusedDay);
                            _fetchAttendanceForMonth(focusedDay);
                          },
                          calendarStyle: const CalendarStyle(
                            outsideDaysVisible: false,
                          ),
                          calendarBuilders: CalendarBuilders(
                            // 1. Default day text color based on status
                            defaultBuilder: (context, day, focusedDay) {
                              final att = _getAttendanceForDay(day);
                              if (att != null) {
                                return Center(
                                  child: Text(
                                    '${day.day}',
                                    style: TextStyle(
                                      color: getStatusColor(att.status),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }
                              return null;
                            },
                            // 2. Today Builder
                            todayBuilder: (context, day, focusedDay) {
                              final att = _getAttendanceForDay(day);
                              Color textColor = TColors.primary;
                              if (att != null) {
                                textColor = getStatusColor(att.status);
                              }
                              return Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: textColor.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  width: 35,
                                  height: 35,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${day.day}',
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            },
                            // 3. Selected Builder
                            selectedBuilder: (context, day, focusedDay) {
                              return Center(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: TColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  width: 35,
                                  height: 35,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${day.day}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            },
                            // Remove dots
                            markerBuilder: (context, day, events) => null,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Detail Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Details for ${_selectedDay.day}/${_selectedDay.month}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),

                    _buildSelectedDayDetail(isDark),

                    const SizedBox(height: 40), // Bottom padding
                  ],
                ),
              ),
      ),
    );
  }

  // ------------------- LOGIC & MODALS -------------------

  // UPDATED: Editable Employee Details Modal
  void fetchEmployeeAndShowDetails() async {
    try {
      final employee = await employeeService.fetchEmployeeById(employeeId);
      showEmployeeDetails(employee);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch employee details: $e")),
      );
    }
  }

  // UPDATED: Report Fetching with Loading State
  Future<void> fetchReportAndShow() async {
    setState(() => _isReportLoading = true);

    try {
      final report = await employeeService.fetchMonthlyReport(
          employeeId, _focusedDay.year, _focusedDay.month);

      if (!mounted) return;
      showReportBottomSheet(report);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch report: $e")),
      );
    } finally {
      if (mounted) setState(() => _isReportLoading = false);
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
                Center(
                  child: Text(
                    "Monthly Report",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                TProfileMenu(
                  title: 'Employee',
                  value: report.employeeName,
                  icon: Iconsax.user,
                  onPressed: () {},
                  flex: 5,
                ),
                TProfileMenu(
                  title: 'Month',
                  value: "${report.month}/${report.year}",
                  icon: Iconsax.calendar,
                  onPressed: () {},
                  flex: 5,
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),

                // Attendance Stats
                TProfileMenu(
                    title: 'Total Days',
                    value: report.totalDays.toString(),
                    onPressed: () {},
                    flex: 5),
                TProfileMenu(
                    title: 'Present',
                    value: report.presentDays.toString(),
                    icon: Iconsax.tick_circle,
                    onPressed: () {},
                    flex: 5),
                TProfileMenu(
                    title: 'Half Days',
                    value: report.halfDays.toString(),
                    icon: Iconsax.timer_1,
                    onPressed: () {},
                    flex: 5),
                TProfileMenu(
                    title: 'Absent',
                    value: report.absentDays.toString(),
                    icon: Iconsax.close_circle,
                    onPressed: () {},
                    flex: 5),
                TProfileMenu(
                  title: 'No Clock Out Days',
                  value: report.noClockOutDays.toString(),
                  icon: Iconsax.calendar_1,
                  onPressed: () {},
                  flex: 5,
                ),
                TProfileMenu(
                    title: 'Paid Leave',
                    value: (report.paidLeave - report.holidayCount).toString(),
                    icon: Iconsax.coin,
                    onPressed: () {},
                    flex: 5),
                TProfileMenu(
                    title: 'Holidays',
                    value: report.holidayCount.toString(),
                    icon: Iconsax.calendar_1,
                    onPressed: () {},
                    flex: 5),

                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),

                // Hours
                TProfileMenu(
                    title: 'Total Hours',
                    value: report.totalHoursWorked.toStringAsFixed(2),
                    icon: Iconsax.clock,
                    onPressed: () {},
                    flex: 5),
                TProfileMenu(
                    title: 'Overtime Pay',
                    value: "₹${report.overtimePay.toStringAsFixed(2)}",
                    icon: Iconsax.money,
                    onPressed: () {},
                    flex: 5),

                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),

                // Money
                TProfileMenu(
                    title: 'Salary Earned',
                    value: "₹${report.salaryEarned.toStringAsFixed(2)}",
                    icon: Iconsax.wallet,
                    onPressed: () {},
                    flex: 5),
                TProfileMenu(
                    title: 'Bonus Earned',
                    value: "₹${report.bonusEarned.toStringAsFixed(2)}",
                    icon: Iconsax.gift,
                    onPressed: () {},
                    flex: 5),

                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // UPDATED: Editable Employee Details
  void showEmployeeDetails(Employee employee) {
    final TextEditingController salaryController =
        TextEditingController(text: employee.salary.toString());
    final TextEditingController bonusController =
        TextEditingController(text: employee.bonus.toString());

    final TextEditingController shiftStartController =
        TextEditingController(text: employee.shiftStart ?? "");
    final TextEditingController shiftEndController =
        TextEditingController(text: employee.shiftEnd ?? "");

    Future<void> pickShiftTime(TextEditingController controller) async {
      TimeOfDay initialTime;
      if (controller.text.isNotEmpty && controller.text.contains(':')) {
        final parts = controller.text.split(':');
        initialTime = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 9,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      } else {
        initialTime = const TimeOfDay(hour: 9, minute: 0);
      }

      final picked = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );

      if (picked != null) {
        final hh = picked.hour.toString().padLeft(2, '0');
        final mm = picked.minute.toString().padLeft(2, '0');
        controller.text = "$hh:$mm"; // 24-hour format
        setState(() {});
      }
    }

    final isDark = THelperFunctions.isDarkMode(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: TSizes.defaultSpace,
            right: TSizes.defaultSpace,
            top: TSizes.defaultSpace,
            bottom:
                MediaQuery.of(context).viewInsets.bottom + TSizes.defaultSpace,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Employee Details",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                Text("Name: ${employee.fullName}"),
                Text("ID: ${employee.employeeId}"),
                Text("Email: ${employee.companyEmail ?? "N/A"}"),
                Text("Phone: ${employee.phoneNumber ?? "N/A"}"),
                const SizedBox(height: TSizes.spaceBtwItems),

                // SALARY
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    controller: salaryController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Salary"),
                          SizedBox(width: 6),
                          Icon(Icons.currency_rupee, size: 18),
                        ],
                      ),
                      filled: true,
                      fillColor: isDark ? TColors.dark : TColors.light,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                // BONUS
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    controller: bonusController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Bonus"),
                          SizedBox(width: 6),
                          Icon(Icons.card_giftcard, size: 18),
                        ],
                      ),
                      filled: true,
                      fillColor: isDark ? TColors.dark : TColors.light,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                // SHIFT TIMES
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => pickShiftTime(shiftStartController),
                        child: AbsorbPointer(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TextField(
                              controller: shiftStartController,
                              decoration: InputDecoration(
                                label: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Shift Start"),
                                    SizedBox(width: 6),
                                    Icon(Icons.access_time, size: 18),
                                  ],
                                ),
                                filled: true,
                                fillColor:
                                    isDark ? TColors.dark : TColors.light,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => pickShiftTime(shiftEndController),
                        child: AbsorbPointer(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TextField(
                              controller: shiftEndController,
                              decoration: InputDecoration(
                                label: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Shift End"),
                                    SizedBox(width: 6),
                                    Icon(Icons.access_time_filled, size: 18),
                                  ],
                                ),
                                filled: true,
                                fillColor:
                                    isDark ? TColors.dark : TColors.light,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: TSizes.spaceBtwSections),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text("Close"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      icon: const Padding(
                        padding: EdgeInsets.only(left: TSizes.spaceBtwItems),
                        child: Icon(Icons.save),
                      ),
                      label: const Padding(
                        padding: EdgeInsets.only(right: TSizes.spaceBtwItems),
                        child: Text("Update"),
                      ),
                      onPressed: () async {
                        try {
                          final salary =
                              double.tryParse(salaryController.text) ?? 0;
                          final bonus =
                              double.tryParse(bonusController.text) ?? 0;

                          // Validation
                          if (shiftStartController.text.isNotEmpty &&
                              shiftEndController.text.isNotEmpty) {
                            final startMin =
                                _timeToMinutes(shiftStartController.text);
                            final endMin =
                                _timeToMinutes(shiftEndController.text);

                            if (startMin >= endMin) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Shift start time must be before end time."),
                                ),
                              );
                              return;
                            }
                          }

                          await employeeService.updateSalary(
                              employee.employeeId, salary);
                          await employeeService.updateBonus(
                              employee.employeeId, bonus);

                          if (shiftStartController.text.isNotEmpty &&
                              shiftEndController.text.isNotEmpty) {
                            await employeeService.setShiftTimes(
                              employee.employeeId,
                              shiftStartController.text,
                              shiftEndController.text,
                            );
                          }

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Employee updated successfully")),
                          );

                          Navigator.pop(context);
                          _fetchAttendanceForMonth(_focusedDay);
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Update failed: $e")),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  // UPDATED: Editable Day Details (Admin Override)
  void showDayDetails(DailyAttendance day) {
    bool isPresent = day.status.toLowerCase() == "present";
    bool halfDay = day.status.toLowerCase() == "half-day";
    bool allowOvertime = day.overtimeEnabled ?? false;

    TextEditingController remarksController =
        TextEditingController(text: day.adminRemarks ?? "");
    TextEditingController clockInController = TextEditingController(
        text: day.clockIn != null
            ? DateFormat('yyyy-MM-ddTHH:mm').format(day.clockIn!)
            : '');
    TextEditingController clockOutController = TextEditingController(
        text: day.clockOut != null
            ? DateFormat('yyyy-MM-ddTHH:mm').format(day.clockOut!)
            : '');

    final isDark = THelperFunctions.isDarkMode(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> pickInOutTime(
                TextEditingController controller, DateTime baseDate) async {
              TimeOfDay initialTime;
              if (controller.text.isNotEmpty &&
                  controller.text.contains('T') &&
                  controller.text.length >= 16) {
                final timePart = controller.text.split('T').last;
                final parts = timePart.split(':');
                initialTime = TimeOfDay(
                  hour: int.tryParse(parts[0]) ?? 9,
                  minute: int.tryParse(parts[1]) ?? 0,
                );
              } else {
                initialTime = const TimeOfDay(hour: 9, minute: 0);
              }

              final picked = await showTimePicker(
                context: context,
                initialTime: initialTime,
              );

              if (picked != null) {
                final date = DateTime(
                  baseDate.year,
                  baseDate.month,
                  baseDate.day,
                  picked.hour,
                  picked.minute,
                );
                controller.text =
                    DateFormat('yyyy-MM-ddTHH:mm').format(date); // 24h
                setModalState(() {});
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    TSizes.defaultSpace,
                top: TSizes.defaultSpace,
                left: TSizes.defaultSpace,
                right: TSizes.defaultSpace,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Edit Attendance",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: TColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat.yMMMMd().format(day.date),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text("Current Status: ${day.status}"),
                    if (day.totalHours != null)
                      Text(
                        "Total Hours: ${day.totalHours!.floor()}h ${((day.totalHours! - day.totalHours!.floor()) * 60).round()}m",
                      ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // CLOCK IN
                    GestureDetector(
                      onTap: () => pickInOutTime(clockInController, day.date),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: clockInController,
                          decoration: InputDecoration(
                            label: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Clock In (24h)"),
                                SizedBox(width: 6),
                                Icon(Icons.login, size: 18),
                              ],
                            ),
                            suffixIcon: const Icon(Icons.access_time),
                            filled: true,
                            fillColor: isDark ? TColors.dark : TColors.light,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // CLOCK OUT
                    GestureDetector(
                      onTap: () => pickInOutTime(clockOutController, day.date),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: clockOutController,
                          decoration: InputDecoration(
                            label: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Clock Out (24h)"),
                                SizedBox(width: 6),
                                Icon(Icons.logout, size: 18),
                              ],
                            ),
                            suffixIcon: const Icon(Icons.access_time_filled),
                            filled: true,
                            fillColor: isDark ? TColors.dark : TColors.light,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    CheckboxListTile(
                      title: const Text("Mark Present"),
                      value: isPresent,
                      onChanged: (val) =>
                          setModalState(() => isPresent = val ?? false),
                    ),
                    CheckboxListTile(
                      title: const Text("Mark Half-Day"),
                      value: halfDay,
                      onChanged: (val) =>
                          setModalState(() => halfDay = val ?? false),
                    ),
                    CheckboxListTile(
                      title: const Text("Allow Overtime"),
                      value: allowOvertime,
                      onChanged: (val) =>
                          setModalState(() => allowOvertime = val ?? false),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: remarksController,
                      decoration: InputDecoration(
                        label: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Remarks (optional)"),
                            SizedBox(width: 6),
                            Icon(Icons.sticky_note_2, size: 18),
                          ],
                        ),
                        filled: true,
                        fillColor: isDark ? TColors.dark : TColors.light,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        icon: const Padding(
                          padding: EdgeInsets.only(left: TSizes.spaceBtwItems),
                          child: Icon(Icons.save),
                        ),
                        label: const Padding(
                          padding: EdgeInsets.only(right: TSizes.spaceBtwItems),
                          child: Text("Save"),
                        ),
                        onPressed: () async {
                          try {
                            await employeeService.adminOverride(
                              employeeId: widget.employeeId ?? employeeId,
                              year: day.date.year,
                              month: day.date.month,
                              day: day.day,
                              allowOvertime: allowOvertime,
                              isPresent: isPresent,
                              halfDay: halfDay,
                              remarks: remarksController.text,
                              clockIn: clockInController.text.isNotEmpty
                                  ? clockInController.text
                                  : null,
                              clockOut: clockOutController.text.isNotEmpty
                                  ? clockOutController.text
                                  : null,
                            );
                            if (!mounted) return;
                            Navigator.pop(context);
                            _fetchAttendanceForMonth(_focusedDay);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Attendance updated successfully"),
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Failed: $e")),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
