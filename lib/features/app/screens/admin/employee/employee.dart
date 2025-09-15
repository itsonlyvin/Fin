import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/features/app/screens/admin/employee/widgets/employee_info.dart';
import 'package:t_store/utils/constants/sizes.dart';

class EmployeeAdmin extends StatelessWidget {
  const EmployeeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> employeeName = [
      "Rahul",
      "Anu",
      "Vikram",
      "Priya",
      "Arjun",
      "Neha",
      "Suresh",
      "Divya",
      "Kiran",
      "Kiran",
      "Kiran",
    ];

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
              "Employees",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: TSizes.spaceBtwItems,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: employeeName.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(employeeName[index]),
                    subtitle: Text("Employee ID: ${index + 1}"),
                    onTap: () => Get.to(() => EmployeeInfo(
                          employeeName: employeeName[index],
                        )),
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
