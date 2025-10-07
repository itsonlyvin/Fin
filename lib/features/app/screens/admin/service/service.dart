import 'package:flutter/material.dart';
import 'package:t_store/features/app/screens/admin/service/pages/empidcreation.dart';
import 'package:t_store/features/app/screens/admin/service/pages/holiday_page.dart';
import 'package:t_store/features/app/screens/admin/service/pages/salary_page.dart';

class Service extends StatelessWidget {
  const Service({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ServiceCard(
              title: 'Employee ID',
              icon: Icons.person,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmpIdPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            ServiceCard(
              title: 'Holiday Calendar',
              icon: Icons.calendar_today,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HolidayCalendarPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            ServiceCard(
              title: 'Monthly Salary',
              icon: Icons.payments,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SalaryPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(width: 16),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
