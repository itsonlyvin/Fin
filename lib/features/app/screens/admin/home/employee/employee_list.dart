import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/features/app/screens/admin/home/backservice/employee_model.dart';
import 'package:t_store/features/app/screens/admin/home/backservice/employeeservice.dart';
import 'package:t_store/features/app/screens/admin/home/employee/widgets/employee_info.dart';
import 'package:t_store/utils/constants/sizes.dart';

class EmployeeList extends StatelessWidget {
  final String company;
  const EmployeeList({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final EmployeeService employeeService = EmployeeService();

    return Scaffold(
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
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(employees[index].name),
                          subtitle: Text("Employee ID: ${employees[index].id}"),
                          onTap: () => Get.to(() => EmployeeInfo(
                                employeeId: employees[index].id,
                                employeeName: employees[index].name,
                              )),
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
