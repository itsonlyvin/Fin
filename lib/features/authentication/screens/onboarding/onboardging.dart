import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:t_store/features/app/screens/employee/attendance_history/widgets/specialColumn.dart';
import 'package:t_store/features/authentication/screens/login/login.dart';
import 'package:t_store/utils/constants/colors.dart';
import 'package:t_store/utils/constants/image_strings.dart';
import 'package:t_store/utils/constants/sizes.dart';
import 'package:t_store/utils/helpers/helper_functions.dart';

class Onboardging extends StatelessWidget {
  const Onboardging({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    // Helper method to add transition
    void navigateWithTransition(Widget page) {
      Get.to(
        () => page,
        transition: Transition.rightToLeft, // You can change this
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: TSizes.appBarHeight,
          left: TSizes.spaceBtwSections,
          right: TSizes.spaceBtwSections,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Fin login
              GestureDetector(
                onTap: () => navigateWithTransition(
                  const LoginScreen(
                    logo: TImages.finDarkAppLogo,
                    color1: TColors.fin1,
                    color2: TColors.fin2,
                    isfin: true,
                  ),
                ),
                child: SpecialColumn(
                  dark: dark,
                  child: Hero(
                    tag: 'fin_logo',
                    child: Image(
                      height: 150,
                      image: AssetImage(
                        dark ? TImages.finDarkAppLogo : TImages.finLightAppLogo,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Open login
              GestureDetector(
                onTap: () => navigateWithTransition(
                  const LoginScreen(
                    logo: TImages.openDarkAppLogo,
                    color1: Color.fromARGB(255, 203, 140, 140),
                    color2: Color.fromARGB(255, 206, 103, 197),
                    isfin: false,
                  ),
                ),
                child: SpecialColumn(
                  dark: dark,
                  child: Hero(
                    tag: 'open_logo',
                    child: Image(
                      height: 150,
                      image: AssetImage(
                        dark
                            ? TImages.openDarkAppLogo
                            : TImages.openLightAppLogo,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Admin login
              GestureDetector(
                onTap: () => navigateWithTransition(
                  const LoginScreen(
                    admin: true,
                    logo: TImages.finDarkAppLogo,
                    color1: TColors.fin1,
                    color2: TColors.fin2,
                    isfin: true,
                  ),
                ),
                child: SpecialColumn(
                  dark: dark,
                  child: Hero(
                    tag: 'admin_text',
                    child: SizedBox(
                      height: 150,
                      child: Center(
                        child: Text(
                          "ADMIN",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
