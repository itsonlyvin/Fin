import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:openarms/utils/appconfig.dart';
import 'package:openarms/utils/constants/colors.dart';
import 'package:openarms/utils/constants/sizes.dart';
import 'package:openarms/utils/helpers/helper_functions.dart';
import 'package:table_calendar/table_calendar.dart';

// Holiday model
class Holiday {
  final DateTime date;
  final String status;
  final String adminRemarks;

  Holiday({
    required this.date,
    required this.status,
    required this.adminRemarks,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      date: DateTime.parse(json['date']).toLocal(),
      status: json['status'].toLowerCase(),
      adminRemarks: json['adminRemarks'] ?? '',
    );
  }
}

class HolidayCalendarPage extends StatefulWidget {
  const HolidayCalendarPage({super.key});

  @override
  State<HolidayCalendarPage> createState() => _HolidayCalendarPageState();
}

class _HolidayCalendarPageState extends State<HolidayCalendarPage> {
  // Calendar State
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<Holiday> holidays = [];
  bool _isLoading = false;

  final TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchHolidays(_focusedDay);
  }

  Future<void> fetchHolidays(DateTime date) async {
    setState(() => _isLoading = true);
    final url = Uri.parse(
        "${AppConfig.baseUrl}/admin/holiday/${date.year}/${date.month}");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          holidays = data.map((e) => Holiday.fromJson(e)).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        print("Failed to fetch holidays: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error fetching holidays: $e");
    }
  }

  /// Helper to get specific holiday object for a specific date
  Holiday? _getHolidayForDate(DateTime date) {
    try {
      return holidays.firstWhere(
        (h) => isSameDay(h.date, date),
      );
    } catch (_) {
      return null;
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "holiday":
        return TColors.primary;
      case "half-day":
        return TColors.warning;
      default:
        return TColors.primary;
    }
  }

  // ---------------- API ACTIONS ----------------

  Future<void> postHoliday(DateTime date, String reason) async {
    final url = Uri.parse("${AppConfig.baseUrl}/admin/holiday");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "date": DateFormat('yyyy-MM-dd').format(date),
          "reason": reason,
        },
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Holiday marked for all employees")));
        fetchHolidays(_focusedDay);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed: ${response.body}")));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> putHoliday(DateTime date, String reason) async {
    final url = Uri.parse("${AppConfig.baseUrl}/admin/holiday/manage");
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "date": DateFormat('yyyy-MM-dd').format(date),
          "reason": reason,
        },
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Holiday updated successfully")));
        fetchHolidays(_focusedDay);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed: ${response.body}")));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // ---------------- UI BUILDERS ----------------

  void showEditHolidaySheet(DateTime date) {
    final holiday = _getHolidayForDate(date);
    reasonController.text = holiday?.adminRemarks ?? "";
    final isHoliday = holiday?.status == "holiday";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                isHoliday ? "Edit Holiday" : "Mark Holiday",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              "Date: ${DateFormat.yMMMMd().format(date)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Current Status: ${holiday?.status ?? 'Working Day'}"),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: "Reason",
                hintText: "e.g. Diwali, Independence Day",
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Padding(
                    padding: EdgeInsets.only(left: TSizes.spaceBtwItems),
                    child: Icon(Icons.save),
                  ),
                  label: Padding(
                    padding: const EdgeInsets.only(right: TSizes.spaceBtwItems),
                    child: Text(isHoliday ? "Update" : "Mark Holiday"),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primary),
                  onPressed: () {
                    final reason = reasonController.text.trim();
                    if (reason.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please enter a reason")));
                      return;
                    }

                    if (isHoliday) {
                      putHoliday(date, reason);
                    } else {
                      postHoliday(date, reason);
                    }

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDayDetail(bool isDark) {
    final Holiday? data = _getHolidayForDate(_selectedDay);
    final bool hasData = data != null;

    final color = hasData ? getStatusColor(data.status) : Colors.grey;
    final statusText = hasData ? data!.status.toUpperCase() : "W D";

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
        onTap: () => showEditHolidaySheet(_selectedDay),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat.yMMMMd().format(_selectedDay),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            )
          ],
        ),
        subtitle: hasData && data!.adminRemarks.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Reason: ${data.adminRemarks}",
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              )
            : const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text("Tap to mark as holiday"),
              ),
        trailing: const Icon(Icons.edit, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor:
          isDark ? const Color.fromARGB(255, 0, 0, 0) : TColors.white,
      appBar: AppBar(
        title: const Text("Holiday Calendar"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. Calendar Card
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                  titleTextStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() => _focusedDay = focusedDay);
                  fetchHolidays(focusedDay);
                },
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                ),
                calendarBuilders: CalendarBuilders(
                  // 1. DEFAULT BUILDER: Controls days that are not today and not selected
                  defaultBuilder: (context, day, focusedDay) {
                    final holiday = _getHolidayForDate(day);
                    if (holiday != null) {
                      return Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color:
                                getStatusColor(holiday.status), // COLORED TEXT
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    return null;
                  },

                  // 2. TODAY BUILDER
                  todayBuilder: (context, day, focusedDay) {
                    final holiday = _getHolidayForDate(day);
                    Color textColor = TColors.grey;

                    if (holiday != null) {
                      textColor = getStatusColor(holiday.status);
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

                  // 3. SELECTED BUILDER
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

                  markerBuilder: (context, day, events) => null,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 2. Details Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Details for ${_selectedDay.day}/${_selectedDay.month}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),

          // 3. Detail Card
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildSelectedDayDetail(isDark),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
