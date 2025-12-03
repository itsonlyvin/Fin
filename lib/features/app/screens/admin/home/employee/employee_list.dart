import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openarms/features/app/screens/admin/home/backservice/employee_model.dart';
import 'package:openarms/features/app/screens/admin/home/backservice/employeeservice.dart';
import 'package:openarms/features/app/screens/admin/home/employee/widgets/employee_info.dart';
import 'package:openarms/utils/constants/sizes.dart';
import 'package:openarms/utils/helpers/helper_functions.dart';

class EmployeeList extends StatelessWidget {
  final String company;
  const EmployeeList({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final EmployeeService employeeService = EmployeeService();
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: isDark
          ? const Color.fromARGB(255, 0, 0, 0)
          : const Color.fromARGB(255, 255, 255, 255)
              .withAlpha((255 * 0.1).toInt()),
      body: Padding(
        padding: const EdgeInsets.only(
          top: TSizes.appBarHeight,
          bottom: TSizes.sm,
          left: TSizes.defaultSpace,
          right: TSizes.defaultSpace,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$company Employees",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Expanded(
              child: FutureBuilder<List<Employee>>(
                future: employeeService.fetchEmployees(company),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No employees found"));
                  } else {
                    final employees = snapshot.data!;
                    return ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final employee = employees[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.indigo,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(employee.fullName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ID: ${employee.employeeId}"),
                              ],
                            ),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () => Get.to(() => EmployeeInfo(
                                  employeeId: employee.employeeId,
                                  employeeName: employee.fullName,
                                )),
                          ),
                        );
                      },
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
