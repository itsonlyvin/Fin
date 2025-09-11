import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:t_store/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/constants/text_strings.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

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
              children: [
                Text(
                  "Welcome",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date Time

                  Padding(
                    padding: const EdgeInsets.only(
                      top: TSizes.appBarHeight,
                      //horizontal: TSizes.defaultSpace
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "09:00 AM",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(
                          height: TSizes.sm,
                        ),
                        Text(
                          "Wednesday, Dec 12",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  // Shift Time

                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: TSizes.appBarHeight,
                      //horizontal: TSizes.defaultSpace,
                    ),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 29, 80, 129),
                              Color.fromARGB(255, 206, 130, 220)
                            ],
                            stops: [
                              0.1,
                              0.8
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft),
                        boxShadow: [
                          BoxShadow(
                            color: dark
                                ? const Color.fromARGB(255, 59, 63, 82)
                                : Colors.black, // shadow color
                            blurRadius: 5, // softness
                            spreadRadius: .5, // size
                            // offset: Offset(, 15), // position (x, y)
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "04.48",
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(
                              height: TSizes.sm,
                            ),
                            Text(
                              "Shift Time",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Check in - Check out - Work hours

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Icon(Iconsax.clock),
                          const SizedBox(
                            height: TSizes.sm,
                          ),
                          Text(
                            "04.48",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: TSizes.dividerHeight,
                          ),
                          Text(
                            "In",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Iconsax.clock),
                          const SizedBox(
                            height: TSizes.sm,
                          ),
                          Text(
                            "04.48",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: TSizes.dividerHeight,
                          ),
                          Text(
                            "Out",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Iconsax.tick_circle),
                          const SizedBox(
                            height: TSizes.sm,
                          ),
                          Text(
                            "04.48",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: TSizes.dividerHeight,
                          ),
                          Text(
                            "Hrs",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
