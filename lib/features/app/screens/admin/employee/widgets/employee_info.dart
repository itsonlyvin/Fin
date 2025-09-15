import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/features/app/screens/employee/attendance_history/attendance_history.dart';
import 'package:t_store/features/app/screens/employee/attendance_history/widgets/askleave.dart';
import 'package:t_store/features/app/screens/employee/attendance_history/widgets/news.dart';
import 'package:t_store/features/app/screens/employee/attendance_history/widgets/radiobutton.dart';
import 'package:t_store/features/app/screens/employee/attendance_history/widgets/specialColumn.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/text_strings.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

class EmployeeInfo extends StatelessWidget {
  const EmployeeInfo({
    super.key,
    required this.employeeName,
  });

  final String employeeName;

  //final String name;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    List<int> days = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
    return Scaffold(
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(
              top: TSizes.appBarHeight,
              bottom: TSizes.sm,
              left: TSizes.defaultSpace,
              right: TSizes.defaultSpace,
            ),
            child: Row(
              children: [
                // Company Name
                Text(
                  employeeName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: TSizes.sm,
                  left: TSizes.defaultSpace,
                  right: TSizes.defaultSpace,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // First
                    SpecialColumn(
                      dark: dark,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Date
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date number
                              Text(
                                "27",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              const SizedBox(width: TSizes.defaultSpace),

                              // Weekday + Month
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Wednesday",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    "June 2025",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Text
                          Padding(
                            padding: const EdgeInsets.only(
                                top: TSizes.md, bottom: TSizes.sm),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                "This month status",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ),

                          // progress
                          SizedBox(
                            height: 55,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: days.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        days[index].toString(),
                                      ),
                                      const SizedBox(height: TSizes.sm),
                                      const AttendanceRadio(),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Second
                    SpecialColumn(
                      dark: dark,
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            PrecentIndicator(
                              dark: dark,
                              precentage: 0.7,
                              precentageString: '70',
                              data: 'Atteandace',
                            ),
                            const DividerVertical(),
                            PrecentIndicator(
                              dark: dark,
                              precentage: 0.7,
                              precentageString: '70',
                              data: 'Leave Taken',
                            ),
                            const DividerVertical(),
                            PrecentIndicator(
                              dark: dark,
                              precentage: 0.7,
                              precentageString: '70',
                              data: 'Ongoing Day',
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Third
                    SpecialColumn(
                      dark: dark,
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            LeaveColumn(
                              onTap: () => Get.to(() => const AskLeave()),
                              icon: Iconsax.calendar,
                              text: 'Ask Leave',
                            ),
                            const DividerVertical(),
                            // LeaveColumn(
                            //   icon: Iconsax.ranking,
                            //   text: 'Leader\nBoard',
                            // ),
                            // DividerVertical(),
                            LeaveColumn(
                              onTap: () => Get.to(() => const News()),
                              icon: Iconsax.document,
                              text: 'News',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
