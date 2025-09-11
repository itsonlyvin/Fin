import 'package:flutter/material.dart';
import 'package:t_store/utils/constants/sizes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: TSizes.appBarHeight, horizontal: TSizes.defaultSpace),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Text("Welcome"),
              ],
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Date Time

                    Text("asdaskdhask")

                    // Shift Time

                    // Check in - Check out - Work hours
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
