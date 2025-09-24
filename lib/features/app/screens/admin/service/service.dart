import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/constants/sizes.dart';

class Service extends StatefulWidget {
  const Service({
    super.key,
  });

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  late int selectedYear;
  late int selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedYear = now.year;
    selectedMonth = now.month;
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

  /// Dummy: Show day details
  void showDayDetails(int day) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Day $day Details",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Date: ${DateFormat.yMMMMd().format(
              DateTime(selectedYear, selectedMonth, day),
            )}"),
            const Text("Status: Present"),
            const Text("Clock In: 09:00 AM"),
            const Text("Clock Out: 05:30 PM"),
            const Text("Total Hours: 8.5"),
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
      final status = (day % 7 == 0)
          ? "Holiday"
          : (day % 6 == 0)
              ? "Absent"
              : "Present";
      final color = getStatusColor(status);

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
                  backgroundColor: TColors.primary,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                trailing: const Icon(Icons.info, color: Colors.grey),
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
                          setState(() => selectedMonth = val);
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
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Calendar-like Attendance View
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
