import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    // Dynamic Time & Date
    final now = DateTime.now();
    final formattedTime = DateFormat('hh:mm a').format(now);
    final formattedDate = DateFormat('EEEE, MMM d').format(now);

    // Responsive Circle Size
    final circleSize = MediaQuery.of(context).size.width * 0.5;

    final List<Map<String, dynamic>> items = [
      {"icon": Iconsax.clock, "value": "09:00", "label": "In"},
      {"icon": Iconsax.clock, "value": "06:00", "label": "Out"},
      {"icon": Iconsax.tick_circle, "value": "08:00", "label": "Hrs"},
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
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Welcome 👋",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                //  const Icon(Iconsax.notification, size: 28),
              ],
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date & Time
                  Padding(
                    padding: const EdgeInsets.only(top: TSizes.appBarHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          formattedTime,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: TSizes.sm),
                        Text(
                          formattedDate,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  // Shift Time Circle with Shadow
                  Padding(
                    padding: const EdgeInsets.only(bottom: TSizes.appBarHeight),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: dark
                                ? Colors.black.withValues(alpha: 0.6)
                                : Colors.grey.withValues(alpha: 0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                            offset:
                                const Offset(0, 4), // softer downward shadow
                          ),
                        ],
                      ),
                      child: Container(
                        width: circleSize,
                        height: circleSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 29, 80, 129),
                              Color.fromARGB(255, 206, 130, 220)
                            ],
                            stops: [0.1, 0.8],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "04:48",
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              const SizedBox(height: TSizes.sm),
                              Text(
                                "Shift Time",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Check In / Out / Hours
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: items.map((item) {
                      return Column(
                        children: [
                          Icon(item["icon"] as IconData, size: 28),
                          const SizedBox(height: TSizes.sm),
                          Text(
                            item["value"] as String,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: TSizes.dividerHeight),
                          Text(
                            item["label"] as String,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
