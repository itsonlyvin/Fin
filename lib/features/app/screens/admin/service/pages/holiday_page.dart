import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:t_store/appconfig.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/constants/sizes.dart';

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
  late int selectedYear;
  late int selectedMonth;
  List<Holiday> holidays = [];
  final TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedYear = now.year;
    selectedMonth = now.month;
    fetchHolidays();
  }

  Future<void> fetchHolidays() async {
    final url = Uri.parse(
        "${AppConfig.baseUrl}/admin/holiday/$selectedYear/$selectedMonth");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          holidays = data.map((e) => Holiday.fromJson(e)).toList();
        });
      } else {
        print("Failed to fetch holidays: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching holidays: $e");
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "present":
        return TColors.nodata;
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

  Holiday getHolidayForDay(int day) {
    final date = DateTime(selectedYear, selectedMonth, day);
    return holidays.firstWhere(
      (h) =>
          h.date.year == date.year &&
          h.date.month == date.month &&
          h.date.day == date.day,
      orElse: () => Holiday(
        date: date,
        status: "Not a holiday",
        adminRemarks: "",
      ),
    );
  }

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
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Holiday marked for all employees")));
        fetchHolidays();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed: ${response.body}")));
      }
    } catch (e) {
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
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Holiday updated successfully")));
        fetchHolidays();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed: ${response.body}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void showDayDetails(int day) {
    final holiday = getHolidayForDay(day);
    reasonController.text = holiday.adminRemarks;

    final isHoliday = holiday.status == "holiday";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
            Text("Day $day Details",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            Text("Date: ${DateFormat.yMMMMd().format(holiday.date)}"),
            Text("Status: ${holiday.status}"),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                  labelText: "Reason (if marking holiday)"),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      final reason = reasonController.text.trim();
                      if (reason.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please enter a reason")));
                        return;
                      }

                      if (isHoliday) {
                        putHoliday(holiday.date, reason);
                      } else {
                        postHoliday(holiday.date, reason);
                      }

                      Navigator.pop(context);
                    },
                    child: Center(
                        child: Text(
                            isHoliday ? "Update Holiday" : "Mark Holiday")),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.holiday),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final years = List.generate(5, (i) => DateTime.now().year - i);
    final months = List.generate(12, (i) => i + 1);

    final daysInMonth = DateUtils.getDaysInMonth(selectedYear, selectedMonth);
    final firstDay = DateTime(selectedYear, selectedMonth, 1).weekday;

    final List<Widget> dayWidgets = [];
    const weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    dayWidgets.addAll(weekdays.map((w) => Center(
          child: Text(
            w,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        )));

    for (int i = 1; i < firstDay; i++) {
      dayWidgets.add(const SizedBox());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final holiday = getHolidayForDay(day);
      final color = getStatusColor(holiday.status);

      dayWidgets.add(GestureDetector(
        onTap: () => showDayDetails(day),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Holiday Calendar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                                    .format(DateTime(selectedYear, m))),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => selectedMonth = val);
                          fetchHolidays();
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
                          setState(() => selectedYear = val);
                          fetchHolidays();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.defaultSpace),
            Expanded(
              child: GridView.count(
                crossAxisCount: 7,
                children: dayWidgets,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
