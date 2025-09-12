import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:t_store/features/app/screens/attendance_history/widgets/askleave.dart';
import 'package:t_store/features/app/screens/attendance_history/widgets/news.dart';
import 'package:t_store/features/app/screens/attendance_history/widgets/radiobutton.dart';
import 'package:t_store/features/app/screens/attendance_history/widgets/specialColumn.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

class AttendanceHistory extends StatelessWidget {
  const AttendanceHistory({super.key});

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
                Text(
                  "X",
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
                            const VerticalDivider(
                              color: Colors.black26,
                              thickness: 0.5,
                              width: 20, // space it occupies horizontally
                              indent: 10, // top spacing
                              endIndent: 10, // bottom spacing
                            ),
                            PrecentIndicator(
                              dark: dark,
                              precentage: 0.7,
                              precentageString: '70',
                              data: 'Leave Taken',
                            ),
                            const VerticalDivider(
                              color: Colors.black26,
                              thickness: 0.5,
                              width: 20, // space it occupies horizontally
                              indent: 10, // top spacing
                              endIndent: 10, // bottom spacing
                            ),
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

////
class DividerVertical extends StatelessWidget {
  const DividerVertical({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(
      color: Colors.black26,
      thickness: 0.5,
      width: 20, // space it occupies horizontally
      indent: 0, // top spacing
      endIndent: 0, // bottom spacing
    );
  }
}

////
class LeaveColumn extends StatelessWidget {
  const LeaveColumn({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final dark = THelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: dark
            ? const Color(0xFF1E1E1E) // Dark card color
            : Colors.white,
        width: width / 4,
        child: Column(
          children: [
            Icon(icon),
            Padding(
              padding: const EdgeInsets.only(top: TSizes.sm),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )
          ],
        ),
      ),
    );
  }
}

//////
class PrecentIndicator extends StatelessWidget {
  const PrecentIndicator({
    super.key,
    required this.dark,
    required this.precentage,
    required this.precentageString,
    required this.data,
  });

  final bool dark;
  final String data;
  final double precentage;
  final String precentageString;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CircularPercentIndicator(
        percent: precentage,
        lineWidth: 5,
        backgroundColor: dark ? TColors.darkGrey : TColors.lightGrey,
        radius: 35,
        center: Text(precentageString),
        progressColor: TColors.primary,
        footer: Padding(
          padding: const EdgeInsets.only(top: TSizes.sm),
          child: Text(
            data,
            style: TextStyle(fontSize: 10),
          ),
        ),
      ),
    );
  }
}
